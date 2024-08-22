locals {
  app_stack_name   = "${var.namespace}-stack"
  chart_stack_name = "eck-stack"
}

resource "helm_release" "eck_stack" {
  chart             = local.chart_stack_name
  create_namespace  = false
  dependency_update = true
  name              = local.app_stack_name
  namespace         = kubernetes_namespace_v1.eck_op_ns.metadata.0.name
  repository        = var.helm_repo
  version           = var.helm_chart_version_eck_stack
  values = [
    yamlencode(
      {
        installCRDs = false
      }
    )
  ]
}