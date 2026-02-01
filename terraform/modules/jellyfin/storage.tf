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

resource "kubernetes_persistent_volume_v1" "jellyfin_media_pv" {
  metadata {
    name = "${var.namespace}-media-pv"
    labels = merge(
      local.labels,
      { storage = "media" }
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
        path   = "/volume1/movies-shows"
        server = var.nfs_ipv4
      }
    }
  }

  timeouts {
    create = "2m"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "jellyfin_nfs_pvc" {
  metadata {
    name      = "${var.namespace}-pvc"
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
        storage = "media"
      }
    }
  }
}