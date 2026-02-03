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
        },
        {
          hostname = var.domain
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          tls = {
            mode = "Terminate"
            certificateRefs = [
              {
                kind = "Secret"
                name = kubernetes_manifest.cert.manifest.spec.secretName
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
              group = ""
              kind  = "Service"
              name  = kubernetes_service_v1.jellyfin_service.metadata[0].name
              port  = kubernetes_deployment_v1.jellyfin_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
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

resource "kubernetes_manifest" "jellyfin_tls_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1alpha2"
    kind       = "TLSRoute"

    metadata = {
      name      = "${var.namespace}-tls-route"
      namespace = kubernetes_namespace_v1.jellyfin_ns.metadata.0.name
    }

    spec = {
      parentRefs = [
        {
          name      = var.gateway_class_name
          namespace = var.namespace
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
              port = 443
            }
          ]
        }
      ]
    }
  }
}