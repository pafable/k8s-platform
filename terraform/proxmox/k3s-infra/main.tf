locals {
  default_tags = "k3s"
  host_name    = "hive-ship"

  # proxmox templates
  controller_template = "orc-tmpl-1"
  worker_template     = "orc-tmpl-1"

  # k8s nodes
  controller_node = "behemoth"
  worker_node     = "kraken"
}

resource "null_resource" "time_delay" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "sleep 120"
  }
}

module "k3s_controller" {
  source              = "../../modules/proxmox-vm"
  clone_template      = local.controller_template
  cloud_init_pve_node = local.controller_node
  cores               = 4
  host_node           = local.controller_node
  memory              = 20480
  name                = "${local.host_name}-01"
  os_type             = "cloud-init"
  runcmd              = "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='server --cluster-init --etcd-expose-metrics --disable=traefik --token ${var.k3s_token}' sh - && kubectl apply -f /home/packer/k3s_storage_class.yaml"
  tags                = local.default_tags
}

module "k3s_agent1" {
  source              = "../../modules/proxmox-vm"
  clone_template      = local.worker_template
  cloud_init_pve_node = local.worker_node
  cores               = 4
  host_node           = local.worker_node
  memory              = 20480
  name                = "${local.host_name}-02"
  os_type             = "cloud-init"
  runcmd              = "curl -sfL https://get.k3s.io | K3S_URL=https://${module.k3s_controller.ipv4_address}:6443 K3S_TOKEN=${var.k3s_token} sh -"
  tags                = local.default_tags

  depends_on = [
    module.k3s_controller,
    null_resource.time_delay
  ]
}

# module "k3s_agent2" {
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