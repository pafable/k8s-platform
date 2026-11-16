terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
  }
}
locals {
  app_name = "istio"

  labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "istio_gw_ns" {
  metadata {
    name   = "${local.app_name}-system"
    labels = local.labels
  }
}

resource "helm_release" "istio_base" {
  chart             = var.base_chart_name
  create_namespace  = false
  dependency_update = true
  name              = "${local.app_name}-base"
  namespace         = kubernetes_namespace_v1.istio_gw_ns.metadata[0].name
  repository        = var.app_repo
  version           = var.istio_helm_chart_version
}

resource "helm_release" "istiod" {
  chart             = var.istiod_chart_name
  create_namespace  = false
  dependency_update = true
  name              = "${local.app_name}-istiod"
  namespace         = kubernetes_namespace_v1.istio_gw_ns.metadata[0].name
  repository        = var.app_repo
  version           = var.istio_helm_chart_version
}