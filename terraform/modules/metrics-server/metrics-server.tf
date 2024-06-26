locals {
  app_name = "metrics-server"
  repo     = "https://kubernetes-sigs.github.io/metrics-server/"
  args     = var.is_cloud ? [] : ["--kubelet-insecure-tls"]

  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "metrics_server_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "metrics_server" {
  name             = local.app_name
  repository       = local.repo
  chart            = local.app_name
  namespace        = kubernetes_namespace_v1.metrics_server_ns.metadata.0.name
  create_namespace = false
  version          = var.chart_version

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