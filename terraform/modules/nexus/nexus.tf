locals {
  app_name   = var.ingress_name
  chart_name = "nxrm-ha"
  helm_repo  = "https://sonatype.github.io/helm3-charts/"

  tf_labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      pvc = {
        existingClaim = kubernetes_persistent_volume_claim_v1.nexus_pvc.metadata[0].name
      }
    })
  ]
}

resource "kubernetes_persistent_volume_claim_v1" "nexus_pvc" {
  metadata {
    name      = "${local.app_name}-pvc"
    namespace = kubernetes_namespace_v1.nexus_ns.metadata[0].name
    labels    = local.tf_labels
  }

  spec {
    storage_class_name = var.storage_class_name
    access_modes       = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "50Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_v1" "nexus_pv" {
  metadata {
    name   = "${local.app_name}-pv"
    labels = local.tf_labels
  }

  spec {
    capacity = {
      storage = "50Gi"
    }

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.storage_class_name

    persistent_volume_source {
      nfs {
        path   = "/volume2/fs/nexus"
        server = var.nfs_ipv4
      }
    }
  }
}

resource "kubernetes_namespace_v1" "nexus_ns" {
  metadata {
    name   = local.app_name
    labels = local.tf_labels
  }
}

resource "helm_release" "vault" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.nexus_ns.metadata.0.name
  repository        = local.helm_repo
  values            = local.values
  version           = var.nexus_version
}