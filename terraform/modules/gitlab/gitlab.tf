locals {
  chart_name = "gitlab"
  app_name   = local.chart_name
  domain     = "gitlab.local"
  email      = "me@gitlab.local"

  #   labels = {
  #     "app.kubernetes.io/name"       = local.app_name
  #     "app.kubernetes.io/managed-by" = "terraform"
  #     "app.kubernetes.io/owner"      = var.owner
  #   }

  values = [
    yamlencode(
      {
        certmanager-issuer = {
          email = local.email
        }

        global = {
          hosts = {
            domain = local.domain
          }
        }

        installCRDs = false
      }
    )
  ]
}

resource "kubernetes_namespace_v1" "gitlab_ns" {
  metadata {
    name = local.app_name
    #     labels = local.labels
  }
}

resource "helm_release" "gitlab" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = "default"
  repository        = var.helm_repo
  values            = local.values
  version           = var.helm_chart_version
}