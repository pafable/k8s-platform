locals {
  pg_name          = "pgadmin"
  pgadmin_image    = var.pgadmin_image
  pgadmin_password = length(var.pgadmin_password) == 0 ? nonsensitive(random_password.password.result) : var.pgadmin_password

  pgadmin_labels = {
    "app.kubernetes.io/name"       = local.pg_name
    "app.kubernetes.io/managed-by" = local.labels.app
    "app.kubernetes.io/owner"      = var.owner
  }

  server_data = jsonencode({
    Servers = {
      1 = {
        Group         = "Servers"
        Host          = "10.104.192.212" # TODO: Find a way to get the IP address of the postgresql service
        MaintenanceDB = "postgres"
        Name          = "test-psql-server-01"
        Port          = 5432
        Username      = "postgres"
      }
    }
  })

  preferences_data = jsonencode({
    preferences = {
      "misc:themes:theme" = "dark"
    }
  })
}

resource "random_password" "password" {
  length = 25
}

resource "kubernetes_secret_v1" "pgadmin_secrets" {
  metadata {
    name      = "${local.pg_name}-secrets"
    namespace = var.namespace
    labels    = local.pgadmin_labels
  }

  data = {
    username = var.pgadmin_email
    password = sensitive(local.pgadmin_password)
  }

  type = "Opaque"
}

resource "kubernetes_config_map_v1" "pgadmin_server_json_config_map" {
  metadata {
    name      = "pgadmin4-server-json-config"
    namespace = kubernetes_namespace_v1.postgresql_ns.metadata[0].name
    labels    = local.pgadmin_labels
  }

  data = {
    "server.json" = local.server_data
  }
}

resource "kubernetes_config_map_v1" "pgadmin_preferences_json_config_map" {
  metadata {
    name      = "pgadmin4-preferences-json-config"
    namespace = kubernetes_namespace_v1.postgresql_ns.metadata[0].name
    labels    = local.pgadmin_labels
  }

  data = {
    "preferences.json" = local.preferences_data
  }
}

resource "kubernetes_deployment_v1" "pgadmin_deployment" {
  metadata {
    name      = "${local.pg_name}-server"
    namespace = kubernetes_namespace_v1.postgresql_ns.metadata[0].name

    labels = local.pgadmin_labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.pgadmin_labels
    }

    template {
      metadata {
        name = "${local.pg_name}-server"

        labels = local.pgadmin_labels
      }

      spec {
        container {
          name              = "pgadmin4"
          image             = local.pgadmin_image
          image_pull_policy = "IfNotPresent"

          resources {
            requests = {
              cpu    = "100m"
              memory = "0.3Gi"
            }
          }

          port {
            container_port = 80
            protocol       = "TCP"
          }

          env {
            name  = "PGADMIN_DEFAULT_EMAIL"
            value = var.pgadmin_email
          }

          env {
            name = "PGADMIN_DEFAULT_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "password"
                name = kubernetes_secret_v1.pgadmin_secrets.metadata[0].name
              }
            }
          }

          env {
            name  = "PGADMIN_SERVER_JSON_FILE"
            value = "/pgadmin4/server.json"
          }

          env {
            name  = "PGADMIN_PREFERENCES_JSON_FILE"
            value = "/pgadmin4/preferences.json"
          }

          env {
            name  = "PGADMIN_CONFIG_MAX_LOGIN_ATTEMPTS"
            value = "10"
          }

          env {
            name  = "PGADMIN_CONFIG_ENABLE_PSQL"
            value = "True"
          }

          env {
            name  = "PGADMIN_CONFIG_LOGIN_BANNER"
            value = "'<h4>GO AWAY!</h4>'"
          }

          volume_mount {
            mount_path = "/pgadmin4/server.json"
            sub_path   = "server.json"
            name       = "server-config"
          }

          volume_mount {
            mount_path = "/pgadmin4/preferences.json"
            sub_path   = "preferences.json"
            name       = "preferences-config"
          }
        }

        volume {
          name = "server-config"

          config_map {
            name = kubernetes_config_map_v1.pgadmin_server_json_config_map.metadata[0].name
          }
        }

        volume {
          name = "preferences-config"

          config_map {
            name = kubernetes_config_map_v1.pgadmin_preferences_json_config_map.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "pgadmin_service" {
  metadata {
    name      = "${local.pg_name}-svc"
    namespace = kubernetes_namespace_v1.postgresql_ns.metadata.0.name
    labels    = local.pgadmin_labels
  }

  spec {
    selector = local.pgadmin_labels

    port {
      name        = "${local.pg_name}-port"
      port        = 80
      target_port = kubernetes_deployment_v1.pgadmin_deployment.spec[0].template[0].spec[0].container[0].port[0].container_port
      protocol    = "TCP"
    }
  }
}