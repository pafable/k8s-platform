resource "kubernetes_manifest" "ghost_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "${local.ghost_app}-gateway"
      namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name

      labels = {
        app   = var.app_name
        owner = local.owner
      }
    }

    spec = {
      gatewayClassName = "door"
      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "ghost_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "ghost-backend"
      namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.ghost_gateway.manifest.metadata.name
          sectionName = "http"
        }
      ]

      hostnames = [
        local.domain_name
      ]

      rules = [
        {
          backendRefs = [
            {

              name = kubernetes_service_v1.ghost_service.metadata[0].name
              port = 80
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