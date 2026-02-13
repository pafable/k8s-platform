# output "chaos_mesh_manager_token" {
#   value = module.chaos_mesh.manager_token
# }

output "jellyfin_svc_ip" {
  value = module.jellyfin.exposed_ip
}

output "grafana_svc_ip" {
  value = module.kube_prom.exposed_grafana_ip
}

output "prometheus_svc_ip" {
  value = module.kube_prom.exposed_prometheus_ip
}