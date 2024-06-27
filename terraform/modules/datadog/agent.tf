# resource "kubernetes_manifest" "datadog_agent" {
#   manifest = {
#     apiVersion = "datadoghq.com/v2alpha1"
#     kind       = "DatadogAgent"
#
#     metadata = {
#       name      = "datadog-agent"
#       namespace = kubernetes_namespace_v1.datadog_ns.metadata.0.name
#       labels    = local.labels
#     }
#
#     spec = {
#       global = {
#         clusterName = var.cluster_name
#         registry    = "docker.io/datadog"
#         site        = "datadoghq.com"
#         credentials = {
#           apiSecret = {
#             secretName = kubernetes_secret_v1.datadog_secret.metadata.0.name
#             keyName    = "apiKey"
#           }
#         }
#       }
#
#       override = {
#         clusterAgent = {
#           env = [
#             {
#               name  = "DD_KUBELET_TLS_VERIFY"
#               value = false
#             }
#           ]
#         }
#
#         agent = {
#           env = [
#             {
#               name  = "DD_KUBELET_TLS_VERIFY"
#               value = false
#             }
#           ]
#         }
#       }
#     }
#   }
# }