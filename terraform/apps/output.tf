# output "chaos_mesh_manager_token" {
#   value = module.chaos_mesh.manager_token
# }

output "apps_ips" {
  value = {
    for k, v in module.output_ssm.parameters : k => { ip = v.value }
  }
}

output "foo" {
  value = module.kube_prom.kubernetes.ip
}