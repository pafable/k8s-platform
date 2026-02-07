locals {
  chart_name = "csi-driver-nfs"
  chart_repo = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
}

resource "helm_release" "csi_driver_nfs" {
  chart             = local.chart_name
  create_namespace  = false
  dependency_update = true
  name              = local.chart_name
  namespace         = "kube-system"
  repository        = local.chart_repo
  timeout           = var.timeout
  version           = var.chart_version
  wait              = false
}