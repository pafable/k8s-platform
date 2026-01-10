# # This does not work because ghost does not expose any metrics by default
# # Keeping this because it is a good example of how to create a service monitor
# resource "kubernetes_manifest" "ghost_service_monitor" {
#   manifest = {
#     apiVersion = "monitoring.coreos.com/v1"
#     kind       = "ServiceMonitor"
#
#     metadata = {
#       name = "${var.app_name}-svc-monitor"
#       #       namespace = kubernetes_namespace_v1.ghost_namespace.metadata.0.name
#       namespace = "monitoring"
#       labels    = local.app_labels
#     }
#
#     spec = {
#       jobLabel = local.ghost_app
#
#       selector = {
#         matchLabels = {
#           "app.kubernetes.io/name" = local.ghost_app
#         }
#       }
#
#       namespaceSelector = {
#         matchNames = [kubernetes_namespace_v1.ghost_namespace.metadata.0.name]
#       }
#
#       endpoints = [
#         {
#           interval = "30s"
#           port     = local.ghost_app
#         }
#       ]
#     }
#   }
# }