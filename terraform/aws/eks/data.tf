data "aws_ssm_parameter" "vpc_id" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.cluster_name}/id"
}

data "aws_ssm_parameter" "intra_subnet_ids" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.cluster_name}/intra_subnet_ids"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  provider = aws.parameters
  name     = "/vpc/eks/${local.cluster_name}/private_subnet_ids"
}

## Uncomment this block if you are using client vpn
# data "aws_ssm_parameter" "client_vpn_security_group_id" {
#   provider = aws.parameters
#   name     = "/client/vpn/security/group/id"
# }