data "aws_ssm_parameter" "ca_cert" {
  provider = aws.parameters
  name     = "/ca/cert"
}

data "aws_ssm_parameter" "ca_private_key" {
  provider = aws.parameters
  name     = "/ca/private/key"
}

data "aws_ssm_parameter" "docker_hub_username" {
  provider = aws.parameters
  name     = "/docker/hub/username"
}

data "aws_ssm_parameter" "docker_hub_password" {
  provider = aws.parameters
  name     = "/docker/hub/password"
}

data "aws_ssm_parameter" "aws_dev_access_key" {
  provider = aws.parameters
  name     = "/account/dev/aws/deployer/access/key/id"
}

data "aws_ssm_parameter" "aws_dev_secret_key" {
  provider = aws.parameters
  name     = "/account/dev/aws/deployer/secret/access/key"
}

data "aws_ssm_parameter" "http_server" {
  provider = aws.parameters
  name     = "/proxmox/http/server/ip"
}

data "aws_ssm_parameter" "nfs_server_ip" {
  provider = aws.parameters
  name     = "/nfs/ipv4"
}

data "aws_ssm_parameter" "jenkins_github_token" {
  provider = aws.parameters
  name     = "/jenkins/github/token"
}

data "aws_ssm_parameter" "k3s_kubeconfig_file" {
  provider = aws.parameters
  name     = "/proxmox/k3s/kubeconfig"
}

data "aws_ssm_parameter" "k3s_controller_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/k3s/controller/ipv4"
}

data "aws_ssm_parameter" "k3s_agent1_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent1/ipv4"
}

data "aws_ssm_parameter" "k3s_agent2_ipv4" {
  provider = aws.parameters
  name     = "/proxmox/k3s/agent2/ipv4"
}

data "aws_ssm_parameter" "packer_ssh_password" {
  provider = aws.parameters
  name     = "/packer/ssh/password"
}

data "aws_ssm_parameter" "packer_ssh_username" {
  provider = aws.parameters
  name     = "/packer/ssh/username"
}

data "aws_ssm_parameter" "proxmox_token_id" {
  provider = aws.parameters
  name     = "/proxmox/api/token/id"
}

data "aws_ssm_parameter" "proxmox_token_secret" {
  provider = aws.parameters
  name     = "/proxmox/api/token/secret"
}

data "aws_ssm_parameter" "cert" {
  provider = aws.parameters
  name     = "/jenkins/cert"
}

data "aws_ssm_parameter" "cert_private_key" {
  provider = aws.parameters
  name     = "/jenkins/cert/private/key"
}