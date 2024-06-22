locals {
  app_name            = "chaos-mesh"
  container_runtime   = var.container_runtime == "docker" ? "docker" : "containerd"
  domain_name         = "chaos.local"
  self_signed_ca_name = "self-signed-cluster-ca-issuer"
  socket_path         = var.container_runtime == "docker" ? "/var/run/docker.sock" : (var.container_runtime == "k3s" ? "/run/k3s/containerd/containerd.sock" : "/run/containerd/containerd.sock")
}

resource "kubernetes_namespace_v1" "chaos_ns" {
  metadata {
    name = local.app_name

    labels = {
      "kuma.io/sidecar-injection"    = "enabled"
      "app.kubernetes.io/app"        = local.app_name
      "app.kubernetes.io/managed-by" = "Terraform"
      "app.kubernetes.io/owner"      = var.owner
    }
  }
}

resource "helm_release" "chaos_mesh" {
  name             = local.app_name
  repository       = "https://charts.chaos-mesh.org"
  chart            = local.app_name
  namespace        = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  create_namespace = false
  version          = var.chart_version

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