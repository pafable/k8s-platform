data "aws_ssm_parameter" "aws_dev_access_key_id" {
  provider = aws.parameters
  name     = "/account/dev/aws/deployer/access/key/id"
}

data "aws_ssm_parameter" "aws_dev_secret_key" {
  provider = aws.parameters
  name     = "/account/dev/aws/deployer/secret/access/key"
}

data "aws_ssm_parameter" "discord_id" {
  provider = aws.parameters
  name     = "/discord/server/id"
}

data "aws_ssm_parameter" "discord_token" {
  provider = aws.parameters
  name     = "/discord/server/token"
}

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