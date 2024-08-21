locals {
  app_name   = "elastic"
  chart_name = "${local.app_name}-operator"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "eck_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "eck" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.eck_ns.metadata.0.name
  repository        = var.helm_repo
  version           = var.helm_chart_version
}