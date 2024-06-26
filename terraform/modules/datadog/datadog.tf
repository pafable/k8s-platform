locals {
  app_name   = "datadog"
  chart_name = "datadog-operator"
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
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "datadog_ns" {
  metadata {
    name   = "datadog"
    labels = local.labels
  }
}

resource "helm_release" "datadog_operator" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.datadog_ns.metadata.0.name
  repository        = local.helm_repo
  version           = var.datadog_helm_version
  values            = local.values
}