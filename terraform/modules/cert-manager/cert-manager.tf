locals {
  app_name   = "cert-manager"
  chart_name = local.app_name
  owner      = "devops"
}

resource "helm_release" "cert_manager" {
  chart            = local.chart_name
  create_namespace = true
  name             = local.app_name
  namespace        = local.app_name
  repository       = "https://charts.jetstack.io"
  version          = var.cert_manager_version

  values = [
    yamlencode({
      #         installCRDs = true
      crds = {
        keep = false
      }
    })
  ]
}