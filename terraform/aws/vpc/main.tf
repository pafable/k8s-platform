locals {
  # default tags
  default_tags = {
    app_name      = "k8s-platform"
    code_location = "k8s-platform/terraform/apps/vpc"
    managed_by    = "terraform"
    owner         = var.owner
  }

  enable_karpenter = true
  intra_subnets    = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
  private_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets   = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  vpc_cidr         = "10.1.0.0/16"
}

module "k8s_vpc" {
  source                      = "../../modules/vpc"
  enable_karpenter_subnet_tag = local.enable_karpenter
  intra_subnets               = local.intra_subnets
  name                        = local.default_tags.app_name
  private_subnets             = local.private_subnets
  public_subnets              = local.public_subnets
  vpc_cidr                    = local.vpc_cidr
}