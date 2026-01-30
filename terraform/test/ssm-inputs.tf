data "aws_ssm_parameter" "k3s_controller1_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/talos/controller1/ipv4"
}

data "aws_ssm_parameter" "k3s_controller2_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/talos/controller2/ipv4"
}
