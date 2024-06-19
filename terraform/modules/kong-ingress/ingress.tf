locals {
  app_name   = "kong-ingress"
  chart      = "kong"
  repository = "https://charts.konghq.com"
}

resource "kubernetes_namespace_v1" "kong_ingress_ns" {
  metadata {
    name = var.namespace
    labels = {
      "kuma.io/sidecar-injection" = "enabled"
    }
  }
}

# installs the Kong Ingress Controller
resource "helm_release" "kong_ingress" {
  name             = local.app_name
  repository       = local.repository
  chart            = local.chart
  namespace        = kubernetes_namespace_v1.kong_ingress_ns.metadata[0].name
  create_namespace = false
  timeout          = var.timeout
  version          = var.chart_version

  depends_on = [kubernetes_manifest.kong_gateway_class]
}