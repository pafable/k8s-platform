locals {
  default_tags = "rke2"
  host_name    = "hive-ship"

  rke2_nodes = {
    controller_1 = {
      name = "${local.host_name}-controller-01"
      node = var.node
    }

    controller_2 = {
      name = "${local.host_name}-controller-02"
      node = var.node
    }

    worker_1 = {
      name = "${local.host_name}-worker-01"
      node = var.node
    }

    worker_2 = {
      name = "${local.host_name}-worker-02"
      node = var.node
    }

    worker_3 = {
      name = "${local.host_name}-worker-03"
      node = var.node
    }
  }
}

module "rke2_controller_1" {
  source    = "../../modules/proxmox-vm"
  desc      = "RKE2 k8s controller 1"
  host_node = local.rke2_nodes.controller_1.node
  iso       = var.iso
  memory    = 8192
  name      = local.rke2_nodes.controller_1.name
  tags      = local.default_tags
}

module "rke2_controller_2" {
  source    = "../../modules/proxmox-vm"
  desc      = "RKE2 k8s controller 2"
  host_node = local.rke2_nodes.controller_2.node
  iso       = var.iso
  memory    = 8192
  name      = local.rke2_nodes.controller_2.name
  tags      = local.default_tags
}

module "rke2_worker_1" {
  source    = "../../modules/proxmox-vm"
  desc      = "RKE2 k8s worker 1"
  host_node = local.rke2_nodes.worker_1.node
  iso       = var.iso
  memory    = 8192
  name      = local.rke2_nodes.worker_1.name
  tags      = local.default_tags
}

module "rke2_worker_2" {
  source    = "../../modules/proxmox-vm"
  desc      = "RKE2 k8s worker 2"
  host_node = local.rke2_nodes.worker_2.node
  iso       = var.iso
  memory    = 8192
  name      = local.rke2_nodes.worker_2.name
  tags      = local.default_tags
}

module "rke2_worker_3" {
  source    = "../../modules/proxmox-vm"
  desc      = "RKE2 k8s worker 3"
  host_node = local.rke2_nodes.worker_3.node
  iso       = var.iso
  memory    = 8192
  name      = local.rke2_nodes.worker_3.name
  tags      = local.default_tags
}