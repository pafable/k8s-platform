locals {
  app_name = "postgresql"
  db_user  = "devops_user"
  repo     = "https://charts.bitnami.com/bitnami"
  timezone = "America/New_York"

  values = [
    yamlencode({
      audit = {
        logHostname       = true
        logConnections    = true
        logDisconnections = true
        logTimezone       = local.timezone
      }

      backup = {
        cronjob = {
          timeZone = local.timezone
        }
      }

      global = {
        postgresql = {
          auth = {
            postgresPassword = sensitive(random_password.postgres_password.result)
            username         = sensitive(local.db_user)
            password         = sensitive(random_password.db_user_password.result)
          }
        }
      }

      primary = {
        persistence = {
          size = "20Gi"
        }
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "postgresql_ns" {
  metadata {
    name = var.namespace

    labels = {
      "kuma.io/sidecar-injection"    = "enabled"
      "app.kubernetes.io/app"        = local.app_name
      "app.kubernetes.io/managed-by" = "Terraform"
      "app.kubernetes.io/owner"      = var.owner
    }
  }
}

resource "random_password" "postgres_password" {
  length  = 25
  special = false
}

resource "random_password" "db_user_password" {
  length  = 25
  special = false
}

resource "helm_release" "postgresql_db" {
  name             = local.app_name
  repository       = local.repo
  chart            = local.app_name
  namespace        = kubernetes_namespace_v1.postgresql_ns.metadata[0].name
  create_namespace = false
  version          = var.chart_version
  values           = local.values
}