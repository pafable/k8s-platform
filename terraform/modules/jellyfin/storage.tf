# resource "kubernetes_storage_class_v1" "jellyfin_movies_shows_sc" {
#   metadata {
#     name = "kraken-movies-shows"
#   }
#
#   reclaim_policy      = "Retain"
#   storage_provisioner = "nfs.csi.k8s.io"
#
#   parameters = {
#     server = "kraken.fleet.pafable.com"
#     share  = "/volume1/movies-shows"
#   }
# }

locals {
  pv_paths = [
    "/volume2/fs/jellyfin/cache",
    "/volume2/fs/jellyfin/config",
    "/volume1/movies-shows"
  ]

  nfs_volumes = [
    "cache",
    "config",
    "media"
  ]

  volume_map = zipmap(local.nfs_volumes, local.pv_paths)
}

resource "kubernetes_persistent_volume_v1" "jellyfin_pv" {
  for_each = local.volume_map

  metadata {
    name = "${var.namespace}-${each.key}-pv"
    labels = merge(
      local.labels,
      { storage = each.key }
    )
  }

  spec {
    capacity = {
      storage = "10Gi"
    }

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.storage_class_name

    persistent_volume_source {
      nfs {
        path   = each.value
        server = var.nfs_ipv4
      }
    }
  }

  timeouts {
    create = "2m"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "jellyfin_pvc" {
  for_each = toset(local.nfs_volumes)

  metadata {
    name      = "${var.namespace}-${each.value}-pvc"
    namespace = kubernetes_namespace_v1.jellyfin_ns.metadata[0].name
    labels    = local.labels
  }

  spec {
    storage_class_name = var.storage_class_name
    access_modes       = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    selector {
      match_labels = {
        storage = each.value
      }
    }
  }

  timeouts {
    create = "2m"
  }
}