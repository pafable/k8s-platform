locals {
  owner = "devops"

  labels = {
    "app.kubernetes.io/name"       = var.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = local.owner
    jobLabel                       = var.app_name
  }

  app_image  = "boomb0x/discord-bot-3:0.0.1"
  app_labels = merge(local.labels, var.app_version)
}

resource "kubernetes_namespace_v1" "bot_namespace" {
  metadata {
    name   = var.namespace
    labels = local.app_labels
  }
}

resource "kubernetes_deployment_v1" "bot_deployment" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.bot_namespace.metadata.0.name
    labels    = local.app_labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name" = var.app_name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 3
        max_unavailable = 1
      }
    }

    template {
      metadata {
        labels = merge(
          { "app.kubernetes.io/name" = var.app_name },
          var.app_version
        )
      }

      spec {
        container {
          image = local.app_image
          name  = var.app_name

          env {
            name  = "AWS_ACCESS_KEY_ID"
            value = var.aws_access_key_id
          }

          env {
            name  = "AWS_SECRET_ACCESS_KEY"
            value = var.aws_secret_access_key
          }

          env {
            name  = "DISCORD_ID"
            value = var.discord_id
          }

          env {
            name  = "DISCORD_TOKEN"
            value = var.discord_token
          }
        }
      }
    }
  }
}