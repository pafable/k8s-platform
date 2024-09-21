packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "golden-image" {
  boot_wait = "3s"
  boot_command = [
    "<esc> linux ip=dhcp inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait60>"
  ]
  #   cloud_init               = true
  #   cloud_init_storage_pool  = "local-lvm"
  #   communicator             = "ssh"
  cores                    = 2
  cpu_type                 = "host"
  http_directory           = "../http"
  insecure_skip_tls_verify = true
  iso_checksum             = "md5sum:0ea804ec9eeec8c0995c82df187e6f6f"
  iso_file                 = "local:iso/OracleLinux-R9-U4-x86_64-boot.iso"
  iso_storage_pool         = "local"
  memory                   = 8192
  node                     = "horde"
  os                       = "l26"
  password                 = var.password
  proxmox_url              = "${var.proxmox_url}:8006/api2/json"
  scsi_controller          = "virtio-scsi-single"
  ssh_username             = var.ssh_username
  ssh_password             = var.ssh_password
  tags                     = "packer"
  template_description     = "Base template for orc"
  template_name            = "orc-template-1"
  unmount_iso              = true
  username                 = var.username
  vm_name                  = "packer-image-builder"

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