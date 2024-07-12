locals {
  app_name   = "kong-ingress"
  chart      = "kong"
  repository = "https://charts.konghq.com"

  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
    "kuma.io/sidecar-injection"    = "enabled"
  }

  values = [
    yamlencode({
      extraLabels = local.labels
    })
  ]
}

resource "kubernetes_namespace_v1" "kong_ingress_ns" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

# installs the Kong Ingress Controller
resource "helm_release" "kong_ingress" {
  chart             = local.chart
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.kong_ingress_ns.metadata[0].name
  repository        = local.repository
  timeout           = var.timeout
  values            = local.values
  version           = var.chart_version

  depends_on = [kubernetes_manifest.kong_gateway_class]
}