packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "golden-image" {
  ballooning_minimum       = 0
  boot_wait                = "3s"
  cores                    = var.cores
  cpu_type                 = "host"
  http_directory           = "../kickstarts/http/rocky"
  insecure_skip_tls_verify = true
  iso_file                 = "local:iso/${var.iso_name}"
  iso_storage_pool         = "local"
  memory                   = var.memory
  node                     = var.proxmox_node
  os                       = "l26"
  token                    = var.proxmox_token
  proxmox_url              = "https://${var.proxmox_url}:8006/api2/json"
  scsi_controller          = "virtio-scsi-single"
  ssh_password             = var.ssh_password
  ssh_timeout              = "30m"
  ssh_username             = var.ssh_username
  tags                     = var.template_name
  template_description     = "Base template for Rocky Linux 9.4"
  template_name            = var.template_name
  unmount_iso              = true
  username                 = var.proxmox_username
  vm_name                  = "packer-image-builder"

  boot_command = [
    "<esc> linux ip=dhcp inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]

  disks {
    discard      = true
    disk_size    = "32G"
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
  name    = "builder"
  sources = ["proxmox-iso.golden-image"]

  provisioner "shell" {
    inline = [
      "date > /home/${var.ssh_username}/image_creation_date"
    ]
  }
}