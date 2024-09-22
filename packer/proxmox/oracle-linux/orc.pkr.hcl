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
  http_directory           = "../http"
  insecure_skip_tls_verify = true
  iso_file                 = "local:iso/OracleLinux-R9-U4-x86_64-boot.iso"
  iso_storage_pool         = "local"
  memory                   = 8192
  node                     = "horde"
  os                       = "l26"
  password                 = var.password
  proxmox_url              = "${var.proxmox_url}:8006/api2/json"
  scsi_controller          = "virtio-scsi-single"
  ssh_password             = var.ssh_password
  ssh_timeout              = "30m"
  ssh_username             = var.ssh_username
  tags                     = "packer"
  template_description     = "Base template for orc"
  template_name            = "orc-template-1"
  unmount_iso              = true
  username                 = var.username
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
}