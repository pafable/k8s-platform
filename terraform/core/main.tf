locals {
  ext_ips = toset([
    data.aws_ssm_parameter.k3s_agent1_ipv4.value,
    data.aws_ssm_parameter.k3s_agent2_ipv4.value,
    data.aws_ssm_parameter.k3s_controller_ipv4.value
  ])
}

module "cert_manager" {
  source = "../modules/cert-manager"
}

module "ingress_nginx" {
  source = "../modules/ingress-nginx"
  # this is necessary on k3s only
  external_ips = local.ext_ips
}

module "jenkins" {
  source                      = "../modules/jenkins"
  agent_container_repository  = "boomb0x/myagent"
  agent_container_tag         = "0.0.3"
  aws_dev_deployer_access_key = sensitive(data.aws_ssm_parameter.aws_dev_access_key.value)
  aws_dev_deployer_secret_key = sensitive(data.aws_ssm_parameter.aws_dev_secret_key.value)
  docker_hub_password         = sensitive(data.aws_ssm_parameter.docker_password.value)
  docker_hub_username         = data.aws_ssm_parameter.docker_username.value
  domain                      = var.domain
  ingress_name                = var.ingress
  jenkins_github_token        = data.aws_ssm_parameter.jenkins_github_token.value
  storage_class_name          = "hive-ship-sc" # this is needed for k3s deployment
  depends_on                  = [module.cert_manager]
}