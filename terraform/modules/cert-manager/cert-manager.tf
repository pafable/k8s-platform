locals {
  app_name   = "cert-manager"
  chart_name = local.app_name
  repo       = "https://charts.jetstack.io"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      #         installCRDs = true
      crds = {
        keep = false
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "cert_manager_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "cert_manager" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.cert_manager_ns.metadata.0.name
  repository        = local.repo
  values            = local.values
  version           = var.cert_manager_version
}