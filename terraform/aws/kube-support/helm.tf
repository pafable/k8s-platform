# metrics server is needed for autoscaling (Karpenter)
# not sure if needed by karpenter anymore
# resource "helm_release" "metrics_server" {
#   chart      = local.ms_name
#   name       = local.ms_name
#   namespace  = local.ms_namespace
#   repository = local.ms_chart_repo
#   version    = local.ms_chart_version
# }

# module "ingress_nginx" {
#   source = "../../modules/ingress-nginx"
# }