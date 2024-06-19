locals {
  # Atlantis params
  access_modes      = ["ReadWriteOnce"]
  app_name          = "atlantis"
  atlantis_port     = 4141
  container_image   = "ghcr.io/runatlantis/atlantis:dev-alpine-cc994a3"
  content_type      = "json"
  exposed_port      = 80
  insecure_ssl      = false
  path              = "/healthz"
  period            = 60
  replicas          = 1
  resource_cpu      = "100m"
  resource_memory   = "256Mi"
  scheme            = "HTTP"
  storage           = "5Gi"
  terraform_version = "v1.7.5"

  # Ghost params
  ghost_app   = "ghost"
  ghost_image = "ghost:5.82.2"
  ghost_port  = 2368
}

resource "kubernetes_namespace_v1" "atlantis_namespace" {
  metadata {
    name = local.app_name
  }
}