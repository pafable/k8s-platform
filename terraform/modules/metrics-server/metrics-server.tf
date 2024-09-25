locals {
  app_name = "metrics-server"
  repo     = "https://kubernetes-sigs.github.io/metrics-server/"
  args     = var.is_cloud ? [] : ["--kubelet-insecure-tls"]

  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      ## This args is needed for the metrics-server to work on a docker-desktop cluster
      args         = local.args
      commonLabels = local.labels
      podLabels    = local.labels

      ## Uncomment to allow access to the metrics-server
      #       metrics = {
      #         enabled = true
      #       }
    })
  ]
}

resource "kubernetes_namespace_v1" "metrics_server_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "metrics_server" {
  chart             = local.app_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.metrics_server_ns.metadata.0.name
  repository        = local.repo
  values            = local.values
  version           = var.chart_version
}