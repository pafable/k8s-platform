output "hive_ship_01" {
  value = module.k3s_controller.ipv4_address
}


output "hive_ship_02" {
  value = module.k3s_agent1.ipv4_address
}

output "hive_ship_03" {
  value = module.k3s_agent2.ipv4_address
}

output "hive_ship_04" {
  value = module.k3s_agent3.ipv4_address
}