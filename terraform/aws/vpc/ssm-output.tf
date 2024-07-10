resource "aws_ssm_parameter" "vpc_arn" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/arn"
  type     = "String"
  value    = module.k8s_vpc.vpc_arn
}

resource "aws_ssm_parameter" "vpc_id" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/id"
  type     = "String"
  value    = module.k8s_vpc.vpc_id
}

resource "aws_ssm_parameter" "vpc_intra_subnet_ids" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/intra_subnet_ids"
  type     = "StringList"
  value    = jsonencode(toset(module.k8s_vpc.intra_subnet_ids))
}

resource "aws_ssm_parameter" "vpc_name" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/name"
  type     = "String"
  value    = module.k8s_vpc.vpc_name
}

resource "aws_ssm_parameter" "vpc_private_subnets_ids" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/private_subnet_ids"
  type     = "StringList"
  value    = jsonencode(toset(module.k8s_vpc.private_subnet_ids))
}

resource "aws_ssm_parameter" "vpc_cidr" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/vpc_cidr"
  type     = "String"
  value    = local.vpc_cidr
}