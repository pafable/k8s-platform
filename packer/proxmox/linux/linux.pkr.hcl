packer {
  required_plugins {
    proxmox = {
      version = "1.2.1" # 1.2.2 CPU type option is broken do not upgrade until it is fixed. see line 37 "cpu_type"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  rh_cmd = [
    "<esc><wait>",
    "linux ip=dhcp inst.ks=https://raw.githubusercontent.com/pafable/k8s-platform/refs/heads/master/packer/proxmox/kickstart/${var.distro}/ks.cfg<enter>"
  ]

  ubuntu_cmd = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>",
    "linux /casper/vmlinuz --- ip=dhcp autoinstall ds=\"nocloud-net;seedfrom=http://${local.http_ip}/ubuntu\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>", "<enter><f10><wait>"
  ]

  boot_cmd = var.distro == "debian" || var.distro == "ubuntu" ? local.ubuntu_cmd : local.rh_cmd
  http_ip  = var.is_local ? "{{ .HTTPIP }}:{{ .HTTPPort }}" : "${var.http_server}:9001"
}

source "proxmox-iso" "linux_golden_image" {
  ballooning_minimum       = 0
  boot_command             = local.boot_cmd
  boot_wait                = "3s"
  cores                    = var.cores
  cpu_type                 = "host" # cpu_type is currently broken. Fix is still being worked on https://github.com/hashicorp/packer-plugin-proxmox/issues/307
  http_directory           = var.is_local ? var.http_directory : null
  insecure_skip_tls_verify = true
  memory                   = var.memory
  node                     = var.proxmox_node
  os                       = "l26"
  proxmox_url              = "https://${var.proxmox_url}:8006/api2/json"
  scsi_controller          = "virtio-scsi-single"
  ssh_password             = var.ssh_password
  ssh_timeout              = "15m"
  ssh_username             = var.ssh_username
  tags                     = replace(var.template_name, ".", "_")
  template_description     = format(var.template_description, convert(timestamp(), string))
  template_name            = var.template_name
  token                    = var.proxmox_token
  username                 = var.proxmox_username
  vm_name                  = "packer-${var.distro}-image-builder"

  boot_iso {
    iso_file = "local:iso/${var.iso_name}"
    unmount  = true
    type     = "scsi"
  }

  disks {
    discard      = true
    disk_size    = var.disk_size
    format       = "raw"
    storage_pool = "local-lvm"
    ssd          = true
    type         = "scsi"
  }

  network_adapters {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
  }
}

build {
  name = "builder"
  sources = [
    "proxmox-iso.linux_golden_image"
  ]

  provisioner "file" {
    source      = "../repos/${var.distro}/"
    destination = "/tmp" # packer does not have the permissions to move files to correct dir so /tmp will have to do
  }

  provisioner "file" {
    source      = "../customizations/"
    destination = "/tmp"
  }

  provisioner "shell" {
    scripts         = ["../packer-scripts/00-customization.sh"]
    execute_command = "sudo -E sh '{{.Path}}'"
    timeout         = "5m"
  }
}