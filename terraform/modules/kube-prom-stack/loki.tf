# locals {
#   loki_app_name = "loki"
#   chart_name    = local.loki_app_name
#   loki_domain   = "${local.loki_app_name}.${var.domain}"
#   loki_port     = 3100

# loki_values = [
#   yamlencode(
# {
#   loki = {
#     schemaConfig = {
#       configs = [
#         {
#           from         = "2024-04-01"
#           store        = "tsdb"
#           object_store = "s3"
#           schema       = "v13"
#           index = {
#             prefix = "loki_index_"
#             period = "24h"
#           }
#         }
#       ]
#     }
#
#     ingester = {
#       chunk_encoding = "snappy"
#     }
#
#     querier = {
#       # Default is 4, if you have enough memory and CPU you can increase, reduce if OOMing
#       max_concurrent = 4
#     }
#
#     pattern_ingester = {
#       enabled = true
#     }
#
#     limits_config = {
#       allow_structured_metadata = true
#       volume_enabled            = true
#     }
#
#     deploymentMode = "SimpleScalable"
#
#     storage = {
#       bucketNames = {
#         chunks = local.bucket
#       }
#     }
#   }
# }
# {
#   loki = {
#     image = {
#       tag = "2.9.3"
#     }
#
#     isDefault = false
#   }
# }
# )
# ]
# }

# resource "helm_release" "loki" {
#   chart             = local.chart_name
#   create_namespace  = false
#   dependency_update = true
#   force_update      = true
#   name              = local.loki_app_name
#   namespace         = kubernetes_namespace_v1.kube_prom_ns.metadata.0.name
#   repository        = var.loki_helm_repo
#   # values            = local.loki_values
#   version = var.loki_helm_chart_version
# }