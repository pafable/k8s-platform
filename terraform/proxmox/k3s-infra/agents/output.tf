output "hive_ship_agent_01" {
  value = module.k3s_agent1.ipv4_address
}

output "hive_ship_agent_02" {
  value = module.k3s_agent_2.ipv4_address
}