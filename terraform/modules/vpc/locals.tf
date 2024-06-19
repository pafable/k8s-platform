locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnet_tags = {
    "karpenter.sh/discovery" = var.name # Karpenter discovery tag only for private subnets
  }
}