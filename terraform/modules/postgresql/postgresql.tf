locals {
  app_name = "postgresql"
  db_user  = "devops_user"
  repo     = "https://charts.bitnami.com/bitnami"
  timezone = "America/New_York"

  labels = {
    "app.kubernetes.io/app"        = var.namespace
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
    app                            = var.namespace
  }

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
    name   = var.namespace
    labels = local.labels
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
  chart             = local.app_name
  create_namespace  = false
  dependency_update = true
  name              = var.namespace
  namespace         = kubernetes_namespace_v1.postgresql_ns.metadata[0].name
  repository        = local.repo
  values            = local.values
  version           = var.chart_version
  verify            = false
}