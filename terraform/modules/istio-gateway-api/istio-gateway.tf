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

  tf_labels = {
    "app.kubernetes.io/name"       = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "helm_release" "istio_base" {
  chart             = var.base_chart_name
  create_namespace  = true
  dependency_update = true
  name              = "${local.app_name}-base"
  namespace         = "${local.app_name}-system"
  repository        = var.app_repo
  version           = var.istio_helm_chart_version
}

resource "helm_release" "istiod" {
  chart             = var.istiod_chart_name
  create_namespace  = true
  dependency_update = true
  name              = "${local.app_name}-istiod"
  namespace         = "${local.app_name}-system"
  repository        = var.app_repo
  version           = var.istio_helm_chart_version
}