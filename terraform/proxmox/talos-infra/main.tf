locals {
  default_tags = "talos"
  host_name    = "hive-ship"

  talos_nodes = {
    controller_1 = {
      name = "${local.host_name}-controller-01"
      node = "leviathan"
    }

    controller_2 = {
      name = "${local.host_name}-controller-02"
      node = "leviathan"
    }

    worker_1 = {
      name = "${local.host_name}-worker-01"
      node = "leviathan"
    }

    worker_2 = {
      name = "${local.host_name}-worker-02"
      node = "leviathan"
    }

    worker_3 = {
      name = "${local.host_name}-worker-03"
      node = "leviathan"
    }
  }
}

module "talos_controller_1" {
  source    = "../../modules/proxmox-vm"
  desc      = "Talos k8s controller 1"
  host_node = local.talos_nodes.controller_1.node
  iso       = var.iso
  memory    = 4096
  name      = local.talos_nodes.controller_1.name
  tags      = local.default_tags
}

module "talos_controller_2" {
  source    = "../../modules/proxmox-vm"
  desc      = "Talos k8s controller 2"
  host_node = local.talos_nodes.controller_2.node
  iso       = var.iso
  memory    = 4096
  name      = local.talos_nodes.controller_2.name
  tags      = local.default_tags
}

module "talos_worker_1" {
  source    = "../../modules/proxmox-vm"
  cores     = 2
  desc      = "Talos k8s worker 1"
  host_node = local.talos_nodes.worker_1.node
  iso       = var.iso
  name      = local.talos_nodes.worker_1.name
  tags      = local.default_tags
}

module "talos_worker_2" {
  source    = "../../modules/proxmox-vm"
  cores     = 2
  desc      = "Talos k8s worker 2"
  host_node = local.talos_nodes.worker_2.node
  iso       = var.iso
  name      = local.talos_nodes.worker_2.name
  tags      = local.default_tags
}

module "talos_worker_3" {
  source    = "../../modules/proxmox-vm"
  cores     = 2
  desc      = "Talos k8s worker 3"
  host_node = local.talos_nodes.worker_3.node
  iso       = var.iso
  name      = local.talos_nodes.worker_3.name
  tags      = local.default_tags
}

resource "null_resource" "script_command" {
  provisioner "local-exec" {
    command = "echo 'Please run k8s-platform/talos/setup-talos.sh to install and initialize Talos \nEXECUTE THE SETUP TALOS SCRIPT: \n\n./setup-talos.sh ${module.talos_controller_1.ipv4_address} ${module.talos_controller_2.ipv4_address} ${module.talos_worker_1.ipv4_address} ${module.talos_worker_2.ipv4_address} ${module.talos_worker_3.ipv4_address}\n'"
  }

  depends_on = [
    module.talos_controller_1,
    module.talos_controller_2,
    module.talos_worker_1,
    module.talos_worker_2,
    module.talos_worker_3
  ]
}

resource "null_resource" "talos_script" {
  provisioner "local-exec" {
    command = <<-EOT
      ${path.root}/../../../talos/setup-talos.sh \
        ${module.talos_controller_1.ipv4_address} \
        ${module.talos_controller_2.ipv4_address} \
        ${module.talos_worker_1.ipv4_address} \
        ${module.talos_worker_2.ipv4_address} \
        ${module.talos_worker_3.ipv4_address}
    EOT

    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    null_resource.script_command
  ]
}