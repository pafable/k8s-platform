resource "aws_ssm_parameter" "rpm_srv_ip" {
  provider = aws.parameters
  name     = "/proxmox/rpm/server/ipv4"
  type     = "String"
  value    = module.rpm_srv.ipv4_address
}