resource "kubernetes_manifest" "prometheus_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "prometheus-gateway"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
      labels    = local.labels
    }

    spec = {
      gatewayClassName = var.gateway_class_name
      infrastructure = {
        labels = {
          app = "prometheus"
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
          hostname = "prometheus.${var.domain}"
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

resource "kubernetes_manifest" "prometheus_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "prometheus-http-route"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.prometheus_gateway.manifest.metadata.name
          sectionName = "http"
        },
        {
          kind        = "Gateway"
          name        = kubernetes_manifest.prometheus_gateway.manifest.metadata.name
          sectionName = "https"
        }
      ]

      hostnames = [
        "prometheus.${var.domain}"
      ]

      rules = [
        {
          backendRefs = [
            {
              name   = "kube-prometheus-stack-prometheus"
              port   = 9090
              weight = 100
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

resource "kubernetes_manifest" "prometheus_basic_auth" {
  manifest = {
    apiVersion = "gateway.envoyproxy.io/v1alpha1"
    kind       = "SecurityPolicy"

    metadata = {
      name      = "prometheus-basic-auth"
      namespace = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
      labels    = local.labels
    }

    spec = {
      targetRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "HTTPRoute"
          name  = kubernetes_manifest.prometheus_http_route.manifest.metadata.name
        }
      ]

      basicAuth = {
        users = {
          name = kubernetes_secret_v1.prometheus_ui_secret.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_secret_v1" "prometheus_ui_secret" {
  metadata {
    name      = "prometheus-ui-auth"
    namespace = kubernetes_namespace_v1.kube_prom_ns.metadata[0].name
  }

  data = {
    ".htpasswd" = file("${path.module}/.htpasswd")
  }

  type = "Opaque"
}
