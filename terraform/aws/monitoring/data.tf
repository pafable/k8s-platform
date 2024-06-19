data "aws_eks_cluster" "eks_cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = local.cluster_name
}