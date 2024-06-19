data "aws_ssm_parameter" "vpc_id" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/id"
}

data "aws_ssm_parameter" "intra_subnet_ids" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/intra_subnet_ids"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.default_tags.app_name}/private_subnet_ids"
}

data "aws_ssm_parameter" "server_private_key" {
  provider = aws.parameters
  name     = "/tools/vpn/private/server/key"
}

data "aws_ssm_parameter" "ca_cert" {
  provider = aws.parameters
  name     = "/tools/vpn/ca/cert"
}