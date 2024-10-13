data "aws_ssm_parameter" "behemoth_ip" {
  provider = aws.parameters
  name     = "/proxmox/node/behemoth/ipv4"
}

data "aws_ssm_parameter" "kraken_ip" {
  provider = aws.parameters
  name     = "/proxmox/node/kraken/ipv4"
}

data "aws_ssm_parameter" "dns_server_ip" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/ip"
}

data "aws_ssm_parameter" "tsig_key" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/tsig/key"
}