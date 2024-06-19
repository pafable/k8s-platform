resource "aws_ssm_parameter" "client_vpn_sg_id" {
  provider = aws.parameters
  name     = "/client/vpn/security/group/id"
  type     = "String"
  value    = module.client_vpn.client_vpn_security_group_id
}