data "aws_ssm_parameter" "main_proxmox_node" {
  provider = aws.parameters
  name     = "/proxmox/node/behemoth/ipv4"
}