locals {
  default_tags = "k3s"
  host_name    = "hive-ship"

  # proxmox templates
  controller_template = "orc-tmpl-1"
  worker_template     = "orc-tmpl-1"

  # k8s nodes
  controller_node = "behemoth"
  worker_node     = "kraken"

  # home network
  home_network = "192.168.109.0/24"
}

resource "null_resource" "time_delay" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "sleep 180" # sleep for 3 mins to allow k3s controller to install and initialize before creating the agent
  }
}

module "k3s_controller" {
  source              = "../../modules/proxmox-k3s-vm"
  clone_template      = local.controller_template
  cloud_init_pve_node = local.controller_node
  cores               = 4
  home_network        = local.home_network
  host_node           = local.controller_node
  memory              = 22528
  name                = "${local.host_name}-01"
  os_type             = "cloud-init"
  runcmd              = "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='server --cluster-init --etcd-expose-metrics --disable=traefik --token ${var.k3s_token}' sh - && kubectl apply -f /home/${var.ssh_username}/k3s_storage_class.yaml"
  ssh_username        = var.ssh_username
  tags                = local.default_tags
}

module "k3s_agent1" {
  source              = "../../modules/proxmox-k3s-vm"
  clone_template      = local.worker_template
  cloud_init_pve_node = local.worker_node
  cores               = 4
  home_network        = local.home_network
  host_node           = local.worker_node
  memory              = 30720
  name                = "${local.host_name}-02"
  os_type             = "cloud-init"
  runcmd              = "curl -sfL https://get.k3s.io | K3S_URL=https://${module.k3s_controller.ipv4_address}:6443 K3S_TOKEN=${var.k3s_token} sh -"
  ssh_username        = var.ssh_username
  tags                = local.default_tags

  depends_on = [
    module.k3s_controller,
    null_resource.time_delay
  ]
}

module "k3s_agent2" {
  source              = "../../modules/proxmox-k3s-vm"
  clone_template      = local.worker_template
  cloud_init_pve_node = local.controller_node
  cores               = 4
  home_network        = local.home_network
  host_node           = local.controller_node
  memory              = 8192
  name                = "${local.host_name}-03"
  os_type             = "cloud-init"
  runcmd              = "curl -sfL https://get.k3s.io | K3S_URL=https://${module.k3s_controller.ipv4_address}:6443 K3S_TOKEN=${var.k3s_token} sh -"
  ssh_username        = var.ssh_username
  tags                = local.default_tags

  # waits for agent1 to complete to release lock on node before creating agent2
  depends_on = [
    module.k3s_agent1
  ]
}