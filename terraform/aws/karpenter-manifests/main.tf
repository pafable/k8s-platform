locals {
  cluster_name = "k8s-platform"
  namespace    = "karpenter"

  # default tags
  default_tags = {
    app_name      = local.cluster_name
    branch        = var.branch
    code_location = var.code
    eks_cluster   = local.cluster_name
    managed_by    = "terraform"
    owner         = var.owner
  }
}