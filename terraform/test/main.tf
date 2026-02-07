variable "config_path" {
  description = "Kubernetes config path"
  type        = string
}

variable "config_context" {
  description = "Kubernetes config context"
  type        = string
}

module "jellyfin" {
  source = "../modules/jellyfin"
  controller_ips = [
    nonsensitive(data.aws_ssm_parameter.talos_controller1_ipv4.insecure_value),
    nonsensitive(data.aws_ssm_parameter.talos_controller2_ipv4.insecure_value)
  ]
  nfs_ipv4 = nonsensitive(data.aws_ssm_parameter.nfs_server_ip.insecure_value)
  domain   = "jellyfin-test.home.pafable.com"
}