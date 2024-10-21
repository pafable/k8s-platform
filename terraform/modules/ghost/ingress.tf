# ghost ingress
resource "kubernetes_ingress_v1" "ghost_ingress" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = kubernetes_namespace_v1.ghost_namespace.id
    annotations = {
      "konghq.com/strip-path"                 = true
      "konghq.com/protocols"                  = "https"
      "konghq.com/https-redirect-status-code" = 301
    }
  }

  wait_for_load_balancer = true

  spec {
    ingress_class_name = "ingress-nginx"
    rule {
      host = local.domain_name
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service_v1.ghost_service.metadata[0].name
              port {
                number = kubernetes_service_v1.ghost_service.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [local.domain_name]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
  }
}

# # gateway http route
# resource "kubernetes_manifest" "http_route" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "HTTPRoute"
#
#     metadata = {
#       name      = "ghost-http-route"
#       namespace = kubernetes_namespace_v1.ghost_namespace.metadata[0].name
#       labels    = local.labels
#     }
#
#     spec = {
#       parentRefs = [
#         {
#           name      = "kong"
#           namespace = "kong-ingress"
#         }
#       ]
#
#       rules = [
#         {
#           matches = [
#             {
#               path = {
#                 type  = "PathPrefix"
#                 value = "/"
#               }
#             }
#           ]
#
#           backendRefs = [
#             {
#               kind = "Service"
#               name = "ghost-svc"
#               port = 80
#             }
#           ]
#         }
#       ]
#     }
#   }
# }
#
# # redirect http to https
# resource "kubernetes_manifest" "http_to_https_redirect" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "HTTPRoute"
#
#     metadata = {
#       name      = "ghost-http-to-https-redirect"
#       namespace = kubernetes_namespace_v1.ghost_namespace.metadata[0].name
#       labels    = local.labels
#     }
#
#     spec = {
#       parentRefs = [
#         {
#           name      = "kong"
#           namespace = "kong-ingress"
#         }
#       ]
#
#       rules = [
#         {
#           matches = [
#             {
#               path = {
#                 type  = "PathPrefix"
#                 value = "/"
#               }
#             }
#           ]
#
#           filters = [
#             {
#               type = "RequestRedirect"
#               requestRedirect = {
#                 scheme     = "https"
#                 statusCode = 301
#               }
#             }
#           ]
#         }
#       ]
#     }
#   }
# }