locals {
  app_op_name   = "${var.namespace}-operator"
  chart_op_name = "eck-operator"

  labels = {
    "app.kubernetes.io/deployed-by" = "terraform"
    "app.kubernetes.io/owner"       = var.owner
  }
}

resource "kubernetes_namespace_v1" "eck_op_ns" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "helm_release" "eck_op" {
  chart             = local.chart_op_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_op_name
  namespace         = kubernetes_namespace_v1.eck_op_ns.metadata.0.name
  repository        = var.helm_repo
  version           = var.helm_chart_version_eck_op
}