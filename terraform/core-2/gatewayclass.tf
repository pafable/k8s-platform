resource "kubernetes_manifest" "istio_gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"

    metadata = {
      name = "door-istio"

      labels = {
        jobLabel                       = "core"
        "app.kubernetes.io/name"       = "door-istio"
        "app.kubernetes.io/managed-by" = "terraform"
        "app.kubernetes.io/owner"      = "devops"
      }
    }

    spec = {
      controllerName = "istio.io/gateway-controller"
      description    = "babys first gatewayclass"
    }
  }
}

resource "kubernetes_manifest" "envoy_gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"

    metadata = {
      name = "door-envoy"

      labels = {
        jobLabel                       = "core"
        "app.kubernetes.io/name"       = "door-envoy"
        "app.kubernetes.io/managed-by" = "terraform"
        "app.kubernetes.io/owner"      = "devops"
      }
    }

    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
      description    = "babys first gatewayclass"
    }
  }
}