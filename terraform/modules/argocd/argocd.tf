locals {
  app_name   = "argocd"
  chart_name = "argo-cd"
  helm_repo  = "https://argoproj.github.io/argo-helm"

  tf_labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true # tls is being applied on the ingress so setting insecure to true is fine
        }

        repositories = {
          app-repo = { # use "-" instead of "_"
            name = "main-repo"
            url  = var.app_repo
          }
        }
      }

      crds = {
        install = false
        keep    = false
      }

      global = {
        domain = local.argo_domain
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata {
    name   = "argocd"
    labels = local.tf_labels
  }
}

resource "helm_release" "argodcd" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.argocd_ns.metadata.0.name
  repository        = local.helm_repo
  values            = local.values
  version           = var.argocd_version
}