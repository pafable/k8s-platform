# module "argocd" {
#   source   = "../modules/argocd"
#   app_repo = "https://github.com/pafable/argo-examples"
#   domain   = var.domain
# }

# module "chaos_mesh" {
#   source                        = "../../modules/chaos-mesh"
#   is_dashboard_security_enabled = false
# }

# module "grafana_dashboards" {
#   source         = "../../modules/grafana-dashboards"
#   svc_acct_token = var.svc_acct_token
#   depends_on     = [module.kube_prom_stack]
# }

module "kube_prom_stack" {
  source       = "../modules/kube-prom-stack"
  ingress_name = var.ingress
  is_cloud     = false
}

module "postgresql_db_01" {
  source       = "../modules/postgresql"
  domain       = var.domain
  ingress_name = var.ingress
}

# module "eck" {
#   source = "../../modules/eck"
# }

# module "ghost_1" {
#   source    = "../../modules/ghost"
#   app_name  = "ghost-1"
#   namespace = "ghost-1"
#   replicas  = 5
# }
#
# module "ghost_2" {
#   source      = "../../modules/ghost"
#   app_name    = "ghost-2"
#   app_version = { version = "green" }
#   namespace   = "ghost-2"
#   replicas    = 5
# }

## this is testing how to deploy a helm chart
# resource "kubernetes_namespace_v1" "my_app_ns" {
#   metadata {
#     name = "my-app-ns"
#   }
# }

# resource "helm_release" "my_app" {
#   chart            = "../../../charts/my-helm-chart"
#   create_namespace = false
#   name             = "my-app"
#   namespace        = kubernetes_namespace_v1.my_app_ns.metadata.0.name
#   version          = "0.1.0"
#
#   values = [
#     yamlencode({
#       app = {
#         replicas = 2
#       }
#     })
#   ]
# }