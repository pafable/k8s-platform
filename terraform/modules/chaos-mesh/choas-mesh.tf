locals {
  app_name          = "chaos-mesh"
  container_runtime = var.container_runtime == "docker" ? "docker" : "containerd"
  domain_name       = "chaos.local"
  repo              = "https://charts.chaos-mesh.org"
  issuer            = "self-signed-ca-cluster-issuer"
  socket_path       = var.container_runtime == "docker" ? "/var/run/docker.sock" : (var.container_runtime == "k3s" ? "/run/k3s/containerd/containerd.sock" : "/run/containerd/containerd.sock")

  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }

  values = [
    yamlencode({
      chaosDaemon = {
        runtime    = local.container_runtime
        socketPath = local.socket_path
      }
      dashboard = {
        securityMode = var.is_dashboard_security_enabled
      }
    })
  ]
}

resource "kubernetes_namespace_v1" "chaos_ns" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "helm_release" "chaos_mesh" {
  chart             = local.app_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_name
  namespace         = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  repository        = local.repo
  values            = local.values
  version           = var.chart_version
}