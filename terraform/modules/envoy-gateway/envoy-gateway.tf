locals {
  app_name = "envoy"

  tf_labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "helm_release" "envoy_gateway" {
  chart             = var.gateway_chart_name
  create_namespace  = true
  dependency_update = true
  name              = local.app_name
  namespace         = "${local.app_name}-gateway-system"
  repository        = var.app_repo
  version           = var.envoy_gw_helm_chart_version
}