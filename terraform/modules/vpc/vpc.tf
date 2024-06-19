module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  version             = ">= 5.8.1"
  name                = "${var.name}-vpc"
  azs                 = toset(local.availability_zones)
  cidr                = var.vpc_cidr
  intra_subnets       = toset(var.intra_subnets)
  private_subnet_tags = var.enable_karpenter_subnet_tag ? local.private_subnet_tags : null
  private_subnets     = toset(var.private_subnets)
  public_subnets      = toset(var.public_subnets)
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
}