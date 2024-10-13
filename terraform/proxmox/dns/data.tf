data "aws_ssm_parameter" "controller_ip" {
  provider = aws.parameters
  name     = "/proxmox/k3s/controller/ipv4"
}

data "aws_ssm_parameter" "agent1_ip" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent1/ipv4"
}

data "aws_ssm_parameter" "dns_server_ip" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/ip"
}

data "aws_ssm_parameter" "tsig_key" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/tsig/key"
}