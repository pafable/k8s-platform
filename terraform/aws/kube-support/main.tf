locals {
  cluster_name = "xyz"

  # IAM roles
  sso_role_arns = toset([
    "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/us-east-2/AWSReservedSSO_pafable-org-admin_b71b25dcfa53e54a"
  ])

  # Ingress Nginx
  chart_name = "ingress-nginx"
  chart_repo = "https://kubernetes.github.io/ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.10.1"

  # metrics server helm
  ms_chart_repo    = "https://kubernetes-sigs.github.io/metrics-server/"
  ms_chart_version = "3.12.1"
  ms_name          = "metrics-server"
  ms_namespace     = "kube-system"
  owner            = "pafable"

  # default tags
  default_tags = {
    branch        = var.branch
    code_location = var.code
    eks_cluster   = local.cluster_name
    managed_by    = "terraform"
    owner         = local.owner
  }
}