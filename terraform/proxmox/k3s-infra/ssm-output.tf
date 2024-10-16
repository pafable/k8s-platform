resource "aws_ssm_parameter" "k3s_agent1" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent1/ipv4"
  type     = "String"
  value    = module.k3s_agent1.ipv4_address
}

resource "aws_ssm_parameter" "k3s_agent2" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent2/ipv4"
  type     = "String"
  value    = module.k3s_agent2.ipv4_address
}

resource "aws_ssm_parameter" "k3s_controller" {
  provider = aws.parameters
  name     = "/proxmox/k3s/controller/ipv4"
  type     = "String"
  value    = module.k3s_controller.ipv4_address
}