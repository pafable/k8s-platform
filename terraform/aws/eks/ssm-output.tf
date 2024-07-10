resource "aws_ssm_parameter" "oidc_provider_arn" {
  provider = aws.parameters
  name     = "/eks/${local.cluster_name}/oidc-provider/arn"
  type     = "String"
  value    = module.k8s_eks.oidc_provider_arn
}