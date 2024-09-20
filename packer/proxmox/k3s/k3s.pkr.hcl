packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "golden-image" {
  cores                    = 2
  insecure_skip_tls_verify = true
  iso_checksum             = "md5sum:0ea804ec9eeec8c0995c82df187e6f6f"
  iso_file                 = "local:iso/OracleLinux-R9-U4-x86_64-boot.iso"
  memory                   = 2048
  node                     = "horde"
  os                       = "l26"
  password                 = var.password
  proxmox_url              = "https://horde.home.pafable.com:8006/api2/json"
  ssh_username             = var.ssh_username
  ssh_password             = var.ssh_password
  tags                     = "packer"
  template_name            = "orc-template-1"
  username                 = var.username
  vm_name                  = "packer-image-builder"

  disks {
    disk_size    = "30G"
    storage_pool = "local-lvm"
    type         = "scsi"
  }
}

build {
  name    = "builder"
  sources = ["proxmox-iso.golden-image"]
}