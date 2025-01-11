locals {
  app_name   = "loki-stack"
  chart_name = local.app_name

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode(
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
      {
        loki = {
          isDefault = false
        }
      }
    )
  ]
}

resource "kubernetes_namespace_v1" "loki_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "loki" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  force_update      = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.loki_ns.metadata.0.name
  repository        = var.helm_repo
  values            = local.values
  timeout           = var.timeout
  version           = var.helm_chart_version
}