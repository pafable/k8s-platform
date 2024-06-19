resource "aws_ssm_parameter" "oidc_provider_arn" {
  provider = aws.parameters
  name     = "/eks/${local.cluster_name}/oidc-provider/arn"
  type     = "String"
  value    = module.xyz_eks.oidc_provider_arn
}