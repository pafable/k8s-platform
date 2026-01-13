# module "cert_manager" {
#   source  = "../modules/cert-manager"
#   ca_cert = sensitive(data.aws_ssm_parameter.ca_cert.value)
#   ca_key  = sensitive(data.aws_ssm_parameter.ca_private_key.value)
# }

# module "jenkins" {
#   source                      = "../modules/jenkins"
#   agent_container_repository  = "boomb0x/myagent"
#   agent_container_tag         = "0.0.4"
#   aws_dev_deployer_access_key = sensitive(data.aws_ssm_parameter.aws_dev_access_key.value)
#   aws_dev_deployer_secret_key = sensitive(data.aws_ssm_parameter.aws_dev_secret_key.value)
#   cert                        = sensitive(data.aws_ssm_parameter.cert.value)
#   cert_private_key            = sensitive(data.aws_ssm_parameter.cert_private_key.value)
#   docker_hub_password         = sensitive(data.aws_ssm_parameter.docker_hub_password.value)
#   docker_hub_username         = sensitive(data.aws_ssm_parameter.docker_hub_username.value)
#   domain                      = var.domain
#   http_server                 = sensitive(data.aws_ssm_parameter.http_server.value)
#   ingress_name                = var.ingress
#   jenkins_github_token        = sensitive(data.aws_ssm_parameter.jenkins_github_token.value)
#   k3s_config_file             = sensitive(data.aws_ssm_parameter.k3s_kubeconfig_file.value)
#   nfs_ipv4                    = data.aws_ssm_parameter.nfs_server_ip.value
#   packer_ssh_password         = sensitive(data.aws_ssm_parameter.packer_ssh_password.value)
#   packer_ssh_username         = sensitive(data.aws_ssm_parameter.packer_ssh_username.value)
#   proxmox_token_id            = sensitive(data.aws_ssm_parameter.proxmox_token_id.value)
#   proxmox_token_secret        = sensitive(data.aws_ssm_parameter.proxmox_token_secret.value)
#   storage_class_name          = "bar"
#
#   depends_on = [
#     module.cert_manager
#   ]
# }

# k3s already has this baked in
# do not deploy on k3s
# module "metrics_server" {
#   source   = "../modules/metrics-server"
#   is_cloud = false
# }

# module "nfs_csi" {
#   source = "../modules/nfs-csi"
# }

# module "vault" {
#   source             = "../modules/vault"
#   ingress_name       = var.ingress
#   storage_class_name = kubernetes_storage_class_v1.kraken_nfs_sc.metadata[0].name
#
#   depends_on = [
#     module.cert_manager,
#     kubernetes_storage_class_v1.kraken_nfs_sc
#   ]
# }

module "envoy_gateway" {
  source = "../modules/envoy-gateway"
}

# module "ghost_1" {
#   source   = "../modules/ghost"
#   app_name = "ghost-1"
#
#   controller_ips = [
#     data.aws_ssm_parameter.talos_controller1_ipv4.value,
#     data.aws_ssm_parameter.talos_controller2_ipv4.value
#   ]
#
#   namespace = "ghost-1"
#   replicas  = 2
# }

output "c1_ip" {
  value = nonsensitive(data.aws_ssm_parameter.talos_controller1_ipv4.value)
}

output "c2_ip" {
  value = nonsensitive(data.aws_ssm_parameter.talos_controller2_ipv4.value)
}