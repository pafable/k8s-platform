resource "aws_ssm_parameter" "k3s_controller" {
  provider = aws.parameters
  name     = "/proxmox/k3s/controller/ipv4"
  type     = "String"
  value    = module.k3s_controller_1.ipv4_address
}