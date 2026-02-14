# output "chaos_mesh_manager_token" {
#   value = module.chaos_mesh.manager_token
# }

output "apps_ips" {
  value = module.output_ssm.parameters
}
