data "aws_ssm_parameter" "k3s_join_token" {
  provider = aws.parameters
  name     = "/proxmox/join/token"
}

data "aws_ssm_parameter" "main_proxmox_node" {
  provider = aws.parameters
  name     = "/proxmox/node/behemoth/ipv4"
}

data "aws_ssm_parameter" "k3s_controller_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/k3s/controller/ipv4"
}