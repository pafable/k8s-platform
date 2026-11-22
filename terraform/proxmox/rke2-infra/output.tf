output "controller_01_ip" {
  value = module.talos_controller_1.ipv4_address
}

output "controller_02_ip" {
  value = module.talos_controller_2.ipv4_address
}

output "worker_01_ip" {
  value = module.talos_worker_1.ipv4_address
}

output "worker_02_ip" {
  value = module.talos_worker_2.ipv4_address
}

output "worker_03_ip" {
  value = module.talos_worker_3.ipv4_address
}