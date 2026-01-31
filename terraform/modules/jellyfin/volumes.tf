resource "kubernetes_persistent_volume_claim_v1" "jellyfin_pvc" {
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
  }
}

resource "kubernetes_persistent_volume_v1" "jellyfin_pv" {
  metadata {
    name   = "${var.namespace}-pv"
    labels = local.labels
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
        path   = "/volume2/fs/jenkins"
        server = var.nfs_ipv4
      }
    }
  }
}