data "aws_ssm_parameter" "talos_controller1_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/talos/controller1/ipv4"
}

data "aws_ssm_parameter" "talos_controller2_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/talos/controller2/ipv4"
}

data "aws_ssm_parameter" "nfs_server_ip" {
  provider = aws.parameters
  name     = "/nfs/ipv4"
}