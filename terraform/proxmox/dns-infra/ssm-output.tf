resource "aws_ssm_parameter" "dns_server_ip" {
  provider = aws.parameters
  name     = "/proxmox/dns/server/ip"
  type     = "String"
  value    = module.dns_vm.ipv4_address
}