resource "kubernetes_manifest" "core_gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"

    metadata = {
      name = "door"

      labels = {
        jobLabel                       = "core"
        "app.kubernetes.io/name"       = "door"
        "app.kubernetes.io/managed-by" = "terraform"
        "app.kubernetes.io/owner"      = "devops"
      }
    }

    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
      description    = "babys first gatewayclass"
    }
  }

  depends_on = [module.envoy_gateway]
}