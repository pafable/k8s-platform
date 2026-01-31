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
    nonsensitive(data.aws_ssm_parameter.k3s_controller1_ipv4.insecure_value),
    nonsensitive(data.aws_ssm_parameter.k3s_controller2_ipv4.insecure_value)
  ]
}