resource "kubernetes_manifest" "jellyfin_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "${var.namespace}-gateway"
      namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name

      labels = {
        app   = var.namespace
        owner = var.owner
      }
    }

    spec = {
      gatewayClassName = var.gateway_class_name
      infrastructure = {
        labels = {
          app = "jellyfin"
        }
      }

      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80
        },
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "kraken_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "ghost-backend"
      namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          name = var.gateway_class_name
        }
      ]

      hostnames = [
        var.domain
      ]

      rules = [
        {
          backendRefs = [
            {
              group  = ""
              kind   = "Service"
              name   = kubernetes_service_v1.jellyfin_service.metadata[0].name
              port   = kubernetes_deployment_v1.jellyfin_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
              weight = 10
            }
          ]
        },
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]
        }
      ]
    }
  }
}