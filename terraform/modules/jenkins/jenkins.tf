locals {
  app_name    = "jenkins"
  chart_name  = local.app_name
  jenkins_url = "https://${local.app_name}.local"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      agent = {
        podName = "${local.app_name}-agent"
      }

      controller = {
        installPlugins = local.plugins
        jenkinsUrl     = local.jenkins_url

        persistence = {
          existingClaim = kubernetes_persistent_volume_claim_v1.jenkins_pvc.metadata[0].name
        }
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "jenkins_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "kubernetes_persistent_volume_claim_v1" "jenkins_pvc" {
  metadata {
    name      = "${local.app_name}-pvc"
    namespace = kubernetes_namespace_v1.jenkins_ns.metadata[0].name
    labels    = local.labels
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "helm_release" "jenkins" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.jenkins_ns.metadata.0.name
  repository        = var.helm_repo
  values            = local.values
  version           = var.helm_chart_version
}