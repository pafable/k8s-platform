# locals {
#   access_mode = "ReadWriteOnce"
# }
#
# resource "kubernetes_persistent_volume_v1" "vault_pv" {
#   metadata {
#     name   = "${local.app_name}-pv"
#     labels = local.tf_labels
#   }
#
#   spec {
#     access_modes                     = [local.access_mode]
#     persistent_volume_reclaim_policy = "Retain"
#     storage_class_name               = var.storage_class_name
#     capacity = {
#       storage = "50Gi"
#     }
#
#     persistent_volume_source {
#       nfs {
#         path   = "/volume2/fs/vault"
#         server = "kraken.fleet.pafable.com"
#       }
#     }
#   }
# }

# resource "kubernetes_persistent_volume_claim_v1" "jenkins_pvc" {
#   metadata {
#     name      = "${local.app_name}-pvc"
#     namespace = kubernetes_namespace_v1.vault_ns.metadata[0].name
#     labels    = local.tf_labels
#   }
#
#   spec {
#     storage_class_name = var.storage_class_name
#     access_modes       = [local.access_mode]
#
#     resources {
#       requests = {
#         storage = "50Gi"
#       }
#     }
#   }
# }