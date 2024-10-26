packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  boot_command = var.distro_family == "debian" ? ["<esc> autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort}}/ --- <enter>"] : ["<esc> linux ip=dhcp inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"]
}

source "proxmox-iso" "golden_image" {
  ballooning_minimum       = 0
  boot_command             = local.boot_command
  boot_wait                = "3s"
  cores                    = var.cores
  cpu_type                 = "host"
  http_directory           = var.http_directory
  insecure_skip_tls_verify = true
  iso_file                 = "local:iso/${var.iso_name}"
  iso_storage_pool         = "local"
  memory                   = var.memory
  node                     = var.proxmox_node
  os                       = "l26"
  proxmox_url              = "https://${var.proxmox_url}:8006/api2/json"
  scsi_controller          = "virtio-scsi-single"
  ssh_password             = var.ssh_password
  ssh_timeout              = "30m"
  ssh_username             = var.ssh_username
  tags                     = var.template_name
  template_description     = var.template_description
  template_name            = var.template_name
  token                    = var.proxmox_token
  unmount_iso              = true
  username                 = var.proxmox_username
  vm_name                  = "packer-image-builder"

  disks {
    discard      = true
    disk_size    = var.disk_size
    storage_pool = "local-lvm"
    ssd          = true
    type         = "scsi"
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
}

build {
  name = "builder"
  sources = [
    "proxmox-iso.golden_image"
  ]

  provisioner "shell" {
    inline = [
      "date > /home/${var.ssh_username}/image_creation_date"
    ]
  }
}