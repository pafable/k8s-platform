data "aws_ssm_parameter" "k3s_join_token" {
  provider = aws.parameters
  name     = "/proxmox/join/token"
}