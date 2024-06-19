resource "aws_ssm_parameter" "karpenter_node_iam_role_arn" {
  provider = aws.parameters
  name     = "/eks/karpenter/node-iam-role/arn"
  type     = "String"
  value    = module.karpenter.node_iam_role_arn
}

resource "aws_ssm_parameter" "karpenter_node_iam_role_name" {
  provider = aws.parameters
  name     = "/eks/karpenter/node-iam-role/name"
  type     = "String"
  value    = module.karpenter.node_iam_role_name
}