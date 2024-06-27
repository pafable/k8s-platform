locals {
  app_name   = "datadog"
  chart_name = local.app_name
  helm_repo  = "https://helm.datadoghq.com"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      datadog = {
        apiKey      = var.datadog_api_key
        appKey      = var.datadog_app_key
        clusterName = var.cluster_name

        confd = {
          "postgres.yaml" = {
            init_config = { # ???
              instances = [
                {
                  host     = var.db_host
                  port     = 5432
                  user     = var.db_user
                  password = var.db_password
                  dbname   = var.db_name
                }
              ]
            }
          }
        }
      }

      watchNamespaces = [""] # using "" will monitor all namespaces
    })
  ]
}

resource "kubernetes_namespace_v1" "datadog_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "kubernetes_secret_v1" "datadog_secret" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace_v1.datadog_ns.metadata.0.name
    labels    = local.labels
  }

  data = {
    apiKey = var.datadog_api_key
  }

  type = "Opaque"
}

resource "helm_release" "datadog" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.datadog_ns.metadata.0.name
  repository        = local.helm_repo
  version           = var.datadog_helm_version
  values            = local.values
}