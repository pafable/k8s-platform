data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = local.cluster_name
}

data "aws_ssm_parameter" "karpenter_node_iam_role_name" {
  provider = aws.parameters
  name     = "/eks/karpenter/node-iam-role/name"
}