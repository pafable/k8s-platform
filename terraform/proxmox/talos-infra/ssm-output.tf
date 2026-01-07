resource "aws_ssm_parameter" "controller1_ip" {
  provider = aws.parameters
  name     = "/proxmox/talos/controller1/ipv4"
  type     = "String"
  value    = module.talos_controller_1.ipv4_address
}

resource "aws_ssm_parameter" "controller2_ip" {
  provider = aws.parameters
  name     = "/proxmox/talos/controller2/ipv4"
  type     = "String"
  value    = module.talos_controller_2.ipv4_address
}