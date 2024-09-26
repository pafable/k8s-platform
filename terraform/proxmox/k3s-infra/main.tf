locals {
  default_tags = "k3s"
  host_name    = "uruk-hai"

  # proxmox templates
  controller_template = "orc-tmpl-1"
  worker_template     = "roc-tmpl-1"

  # k8s nodes
  controller_node = "horde"
  worker_node     = "ninja"
}

module "k3s_master" {
  source   = "../../modules/proxmox_vm"
  clone    = local.controller_template
  memory   = 16384
  name     = "${local.host_name}-01"
  os_type  = "cloud-init"
  pve_node = local.controller_node
  runcmd   = "curl -sfL https://get.k3s.io | sh -"
  tags     = local.default_tags
}

# module "k3s_worker1" {
#   source    = "../../modules/proxmox_vm"
#   clone     = local.worker_template
#   host_node = local.worker_node
#   memory    = 16384
#   name      = "${local.host_name}-02"
#   os_type   = "cloud-init"
#   pve_node  = local.worker_node
#   tags      = local.default_tags
# }

# module "k3s_worker2" {
#   source     = "../../modules/proxmox_vm"
#   clone      = local.worker_template
#   host_node  = local.worker_node
#   memory     = 8192
#   name       = "${local.host_name}-03"
#   os_type    = "cloud-init"
#   pve_node   = local.worker_node
#   tags       = local.default_tags
#   depends_on = [module.k3s_worker1] # waits for worker1 to complete to release lock on node before creating worker2
# }