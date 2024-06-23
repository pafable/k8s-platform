locals {
  app_name   = "trivy-operator"
  chart_repo = "https://aquasecurity.github.io/helm-charts/"

  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/owner"      = var.owner
  }
}

resource "kubernetes_namespace_v1" "trivy_ns" {
  metadata {
    name   = "trivy-system"
    labels = local.labels
  }
}

resource "helm_release" "trivy_operator" {
  chart            = local.app_name
  create_namespace = false
  name             = local.app_name
  namespace        = kubernetes_namespace_v1.trivy_ns.metadata.0.name
  repository       = local.chart_repo
  version          = var.trivy_operator_version

  values = [
    yamlencode({
      trivy = {
        additionalVulnerabilityReportFields = "Description,Target,PackageType"
      }
    })
  ]
}