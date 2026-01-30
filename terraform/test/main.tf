module "jellyfin" {
  source = "../modules/jellyfin"
  controller_ips = [
    nonsensitive(data.aws_ssm_parameter.k3s_controller1_ipv4.insecure_value),
    nonsensitive(data.aws_ssm_parameter.k3s_controller2_ipv4.insecure_value)
  ]
}