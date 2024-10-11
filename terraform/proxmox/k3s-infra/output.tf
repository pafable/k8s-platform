output "agent1_default_ipv4" {
  value = module.k3s_agent1.ipv4_address
}

output "controller_default_ipv4" {
  value = module.k3s_controller.ipv4_address
}

