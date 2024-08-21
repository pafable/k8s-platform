module "argocd" {
  source   = "../../modules/argocd"
  app_repo = "https://github.com/pafable/argo-examples"
  depends_on = [
    module.cert_manager,
    module.kong_ingress
  ]
}

module "cert_manager" {
  source = "../../modules/cert-manager"
}

module "chaos_mesh" {
  source                        = "../../modules/chaos-mesh"
  is_dashboard_security_enabled = false
  depends_on                    = [module.cert_manager]
}

# module "grafana_dashboards" {
#   source         = "../../modules/grafana-dashboards"
#   svc_acct_token = var.svc_acct_token
#   depends_on     = [module.kube_prom_stack]
# }

# module "ingress_nginx" {
#   source = "../../modules/ingress-nginx"
# }

module "kong_ingress" {
  source = "../../modules/kong-ingress"
}

# module "kong_mesh" {
#   source = "../../modules/kong-mesh"
# }

module "jenkins" {
  source                      = "../../modules/jenkins"
  agent_container_repository  = "boomb0x/myagent"
  agent_container_tag         = "0.0.3"
  aws_dev_deployer_access_key = sensitive(data.aws_ssm_parameter.aws_dev_access_key.value)
  aws_dev_deployer_secret_key = sensitive(data.aws_ssm_parameter.aws_dev_secret_key.value)
  docker_hub_password         = sensitive(data.aws_ssm_parameter.docker_password.value)
  docker_hub_username         = data.aws_ssm_parameter.docker_username.value
  jenkins_github_token        = data.aws_ssm_parameter.jenkins_github_token.value
  depends_on                  = [module.cert_manager]
}

module "kube_prom_stack" {
  source     = "../../modules/kube-prom-stack"
  is_cloud   = false
  depends_on = [module.cert_manager]
}

module "metrics_server" {
  source   = "../../modules/metrics-server"
  is_cloud = false
}

module "postgresql_db_01" {
  source     = "../../modules/postgresql"
  depends_on = [module.cert_manager]
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

# module "trivy_operator" {
#   source = "../../modules/trivy-operator"
# }

## this is testing how to deploy a helm chart
# resource "kubernetes_namespace_v1" "my_app_ns" {
#   metadata {
#     name = "my-app-ns"
#   }
# }
#
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