data "aws_ssm_parameter" "k3s_join_token" {
  provider = aws.parameters
  name     = "/proxmox/join/token"
}

data "aws_ssm_parameter" "main_proxmox_node" {
  provider = aws.parameters
  name     = "/proxmox/node/behemoth/ipv4"
}