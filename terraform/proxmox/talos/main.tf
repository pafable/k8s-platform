locals {
  default_tags = "talos"
  cluster_name = "${local.default_tags}-cluster"
  host_name    = "hive-ship"

  talos_nodes = {
    controller_1 = {
      name = "${local.host_name}-controller-01"
      node = "behemoth"
    }

    worker_1 = {
      name = "${local.host_name}-worker-01"
      node = "behemoth"
    }

    worker_2 = {
      name = "${local.host_name}-worker-02"
      node = "behemoth"
    }
  }
}

module "talos_controller_1" {
  source    = "../../modules/proxmox-vm"
  desc      = "talos k8s controller"
  host_node = local.talos_nodes.controller_1.node
  iso       = var.iso
  memory    = 4096
  name      = local.talos_nodes.controller_1.name
  tags      = local.default_tags
}

module "talos_worker_1" {
  source     = "../../modules/proxmox-vm"
  cores      = 2
  desc       = "Talos k8s worker 1"
  host_node  = local.talos_nodes.worker_1.node
  iso        = var.iso
  memory     = 2048
  name       = local.talos_nodes.worker_1.name
  tags       = local.default_tags
  # depends_on = [module.talos_controller_1]
}

module "talos_worker_2" {
  source     = "../../modules/proxmox-vm"
  cores      = 2
  desc       = "Talos k8s worker 2"
  host_node  = local.talos_nodes.worker_2.node
  iso        = var.iso
  memory     = 2048
  name       = local.talos_nodes.worker_2.name
  tags       = local.default_tags
  # depends_on = [module.talos_worker_1]
}

resource "null_resource" "setup_talos" {
  provisioner "local-exec" {
    command = <<-EOT
      bash ${path.module}/setup-talos.sh \
        ${module.talos_controller_1.ipv4_address} \
        ${module.talos_worker_1.ipv4_address} \
        ${module.talos_worker_2.ipv4_address}
    EOT
  }

  depends_on = [module.talos_worker_2]
}