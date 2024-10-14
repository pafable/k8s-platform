locals {
  app_name   = "vault"
  chart_name = "hashicorp/${local.app_name}"
  helm_repo  = "https://helm.releases.hashicorp.com"

  tf_labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
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
  version           = var.vault_version
}