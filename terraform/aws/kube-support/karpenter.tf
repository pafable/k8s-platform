module "karpenter" {
  source            = "../../modules/karpenter"
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_name      = data.aws_eks_cluster.cluster.name
  code              = local.default_tags.code_location
  oidc_provider_arn = data.aws_ssm_parameter.oidc_arn.value
  owner             = var.owner
}