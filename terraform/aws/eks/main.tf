locals {
  cluster_name = "k8s-platform"
  #   worker_node_instance_types = ["t2.micro"]

  # default tags
  default_tags = {
    app_name      = local.cluster_name
    code_location = var.code
    eks_cluster   = local.cluster_name
    managed_by    = "terraform"
    owner         = var.owner
  }
}

module "k8s_eks" {
  source = "../../modules/eks"
  ## uncomment client_vpn_security_group_id to enable client vpn access
  #   client_vpn_security_group_id = data.aws_ssm_parameter.client_vpn_security_group_id.value
  cluster_name         = local.cluster_name
  enable_public_access = true
  intra_subnet_ids     = jsondecode(data.aws_ssm_parameter.intra_subnet_ids.value)
  node_desired_size    = 3
  private_subnet_ids   = jsondecode(data.aws_ssm_parameter.private_subnet_ids.value)
  sso_role_arn         = data.aws_ssm_parameter.aws_sso_role_arn.value
  vpc_id               = data.aws_ssm_parameter.vpc_id.value

  ## sets EKS worker node instance types
  #   instance_types = toset(local.worker_node_instance_types)
}