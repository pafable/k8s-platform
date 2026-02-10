resource "kubernetes_manifest" "grafana_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "grafana-gateway"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
      labels    = local.labels
    }

    spec = {
      gatewayClassName = var.gateway_class_name
      infrastructure = {
        labels = {
          app = "grafana"
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
          hostname = "grafana.${var.domain}"
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
                namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
              }
            ]
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "grafana_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "grafana-http-route"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.grafana_gateway.manifest.metadata.name
          sectionName = "http"
        },
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.grafana_gateway.manifest.metadata.name
          sectionName = "https"
        }
      ]

      hostnames = [
        "grafana.${var.domain}"
      ]

      rules = [
        {
          backendRefs = [
            {
              name = "kube-prometheus-stack-grafana"
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