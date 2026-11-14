resource "kubernetes_manifest" "podinfo_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "${local.app_name}-gateway"
      namespace = kubernetes_namespace_v1.podinfo_ns.metadata.0.name

      labels = {
        app   = local.app_name
        owner = var.owner
      }
    }

    spec = {
      gatewayClassName = var.gateway_class_name

      infrastructure = {
        labels = {
          app = local.app_name
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
          hostname = local.podinfo_domain
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
                name      = kubernetes_manifest.podinfo_cert.manifest.spec.secretName
                namespace = kubernetes_namespace_v1.podinfo_ns.metadata.0.name
              }
            ]
          }
        }
      ]
    }
  }

  wait {
    condition {
      type   = "Programmed"
      status = "True"
    }
  }
}

resource "kubernetes_manifest" "podinfo_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "${local.app_name}-http-route"
      namespace = kubernetes_namespace_v1.podinfo_ns.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.podinfo_gateway.manifest.metadata.name
          sectionName = "http"
        },
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.podinfo_gateway.manifest.metadata.name
          sectionName = "https"
        }
      ]

      hostnames = [
        local.podinfo_domain
      ]

      rules = [
        {
          backendRefs = [
            {
              name = local.podinfo_server_service
              port = local.podinfo_server_port
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