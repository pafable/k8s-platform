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
  cores                    = 4
  cpu_type                 = "host"
  http_directory           = "../kickstarts/http/oracle"
  insecure_skip_tls_verify = true
  iso_file                 = "local:iso/OracleLinux-R9-U4-x86_64-boot.iso"
  iso_storage_pool         = "local"
  memory                   = 8192
  node                     = var.proxmox_node
  os                       = "l26"
  password                 = var.proxmox_password
  proxmox_url              = "https://${var.proxmox_url}:8006/api2/json"
  scsi_controller          = "virtio-scsi-single"
  ssh_password             = var.ssh_password
  ssh_timeout              = "30m"
  ssh_username             = var.ssh_username
  tags                     = var.template_name
  template_description     = "Base template for Oracle Linux 9.4"
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
    inline = ["date > /home/${var.ssh_username}/image_creation_date"]
  }
}