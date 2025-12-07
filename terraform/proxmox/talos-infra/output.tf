output "controller_01_ip" {
  value = module.talos_controller_1.ipv4_address
}

output "worker_01_ip" {
  value = module.talos_worker_1.ipv4_address
}

output "worker_02_ip" {
  value = module.talos_worker_2.ipv4_address
}