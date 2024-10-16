# DNS server
data "aws_ssm_parameter" "dns_server_ip" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/ip"
}

# DNS tsig key
data "aws_ssm_parameter" "tsig_key" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/tsig/key"
}

# proxmox nodes
data "aws_ssm_parameter" "behemoth_ip" {
  provider = aws.parameters
  name     = "/proxmox/node/behemoth/ipv4"
}

data "aws_ssm_parameter" "kraken_ip" {
  provider = aws.parameters
  name     = "/proxmox/node/kraken/ipv4"
}

# k3s nodes
data "aws_ssm_parameter" "k3s_controller_ip" {
  provider = aws.parameters
  name     = "/proxmox/k3s/controller/ipv4"
}

data "aws_ssm_parameter" "k3s_agent1_ip" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent1/ipv4"
}

data "aws_ssm_parameter" "k3s_agent2_ip" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent2/ipv4"
}