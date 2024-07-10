locals {
  cluster_name = "k8s-platform"

  # IAM roles
  sso_role_arns = toset([
    data.aws_ssm_parameter.aws_sso_role_arn.value
  ])

  # default tags
  default_tags = {
    branch        = var.branch
    code_location = var.code
    eks_cluster   = local.cluster_name
    managed_by    = "terraform"
    owner         = var.owner
  }
}

# module "argocd" {
#   source   = "../../modules/argocd"
#   app_repo = "https://github.com/pafable/argo-examples"
#   depends_on = [
#     module.cert_manager,
#     module.kong_ingress
#   ]
# }

module "cert_manager" {
  source = "../../modules/cert-manager"
}

# module "chaos_mesh" {
#   source                        = "../../modules/chaos-mesh"
#   is_dashboard_security_enabled = false
#   depends_on                    = [module.cert_manager]
# }

module "ingress_nginx" {
  source = "../../modules/ingress-nginx"
}

module "karpenter" {
  source            = "../../modules/karpenter"
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_name      = data.aws_eks_cluster.cluster.name
  code              = local.default_tags.code_location
  oidc_provider_arn = data.aws_ssm_parameter.oidc_arn.value
  owner             = var.owner
}

module "kong_ingress" {
  source  = "../../modules/kong-ingress"
  timeout = 500
}

module "kube_prom_stack" {
  source     = "../../modules/kube-prom-stack"
  is_cloud   = false
  depends_on = [module.cert_manager]
}

# metrics server is needed for autoscaling (Karpenter)
module "metrics_server" {
  source   = "../../modules/metrics-server"
  is_cloud = false
}

# module "postgresql_db_01" {
#   source     = "../../modules/postgresql"
#   depends_on = [module.cert_manager]
# }

# module "trivy_operator" {
#   source = "../../modules/trivy-operator"
# }