locals {
  app_name   = "vault"
  chart_name = local.app_name
  helm_repo  = "https://helm.releases.hashicorp.com"

  tf_labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      server = {

        dev = {
          enabled = var.is_dev
        }

        # ha = {
        #   enabled = false
        #
        #   raft = {
        #     enabled = true
        #   }
        # }
      }

      ui = {
        enabled     = true
        serviceType = "LoadBalancer"
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "vault_ns" {
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
  namespace         = kubernetes_namespace_v1.vault_ns.metadata.0.name
  repository        = local.helm_repo
  values            = local.values
  version           = var.vault_version
}