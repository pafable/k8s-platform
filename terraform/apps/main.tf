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

# module "discord_bot" {
#   source                = "../modules/discord-bot-3"
#   aws_access_key_id     = sensitive(data.aws_ssm_parameter.aws_dev_access_key_id.value)
#   aws_secret_access_key = sensitive(data.aws_ssm_parameter.aws_dev_secret_key.value)
#   discord_id            = sensitive(data.aws_ssm_parameter.discord_id.value)
#   discord_token         = sensitive(data.aws_ssm_parameter.discord_token.value)
# }

# module "kube_prom_stack" {
#   source       = "../modules/kube-prom-stack"
#   ingress_name = var.ingress
#   is_cloud     = false
# }

# module "postgresql_db_01" {
#   source       = "../modules/postgresql"
#   domain       = var.domain
#   ingress_name = var.ingress
# }

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

module "jellyfin" {
  source = "../modules/jellyfin"
  controller_ips = [
    nonsensitive(data.aws_ssm_parameter.talos_controller1_ipv4.insecure_value),
    # nonsensitive(data.aws_ssm_parameter.talos_controller2_ipv4.insecure_value)
  ]
  nfs_ipv4 = nonsensitive(data.aws_ssm_parameter.nfs_server_ip.insecure_value)
  domain   = "jellyfin.${var.domain}"
}