locals {
  install_count = tobool(data.external.check_crd.result["installed"]) ? 1 : 0
}

resource "kubernetes_manifest" "kong_gateway_class" {
  count = local.install_count
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"

    metadata = {
      name = "kong"
      annotations = {
        "konghq.com/gatewayclass-unmanaged" = "true"
      }
      labels = local.labels
    }

    spec = {
      controllerName = "konghq.com/kic-gateway-controller"
    }
  }
}

resource "kubernetes_manifest" "kong_gateway" {
  count = local.install_count
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "kong"
      namespace = kubernetes_namespace_v1.kong_ingress_ns.metadata.0.name
      labels    = local.labels
    }

    spec = {
      gatewayClassName = "kong"
      listeners = [
        {
          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
          name     = "http"
          port     = 80
          protocol = "HTTP"
        },
        {
          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
          name     = "https"
          port     = 443
          protocol = "HTTPS"
          tls = {
            mode = "Passthrough"
          }
        }
      ]
    }
  }
  depends_on = [kubernetes_manifest.kong_gateway_class]
}