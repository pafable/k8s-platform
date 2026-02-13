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
          app = var.namespace
        }
      }

      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80

          allowedRoutes = {
            namespaces = {
              from = "Same"
            }
          }
        },
        {
          hostname = var.domain
          name     = "https"
          protocol = "HTTPS"
          port     = 443

          allowedRoutes = {
            namespaces = {
              from = "Same"
            }
          }

          tls = {
            mode = "Terminate"
            certificateRefs = [
              {
                name      = kubernetes_manifest.cert.manifest.spec.secretName
                namespace = var.namespace
              }
            ]
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "jellyfin_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "${var.namespace}-http-route"
      namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.jellyfin_gateway.manifest.metadata.name
          sectionName = "http"
        },
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.jellyfin_gateway.manifest.metadata.name
          sectionName = "https"
        }
      ]

      hostnames = [
        var.domain
      ]

      rules = [
        {
          backendRefs = [
            {
              name = kubernetes_service_v1.jellyfin_service.metadata[0].name
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
        },
        {
          filters = [
            {
              ## redirects http to https
              type = "RequestRedirect"
              requestRedirect = {
                scheme     = "https"
                statusCode = 301
              }
            }
          ]
        }
      ]
    }
  }
}