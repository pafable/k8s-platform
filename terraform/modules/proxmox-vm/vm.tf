locals {
  local_storage_pool = "local"
  creation_date      = timestamp() # timestamps are in Zulu aka UTC time
  description        = "${var.desc}. Instance launched on ${local.creation_date}"
}

resource "proxmox_cloud_init_disk" "cloudinit" {
  name     = "${var.name}-cloudinit"
  pve_node = var.cloud_init_pve_node
  storage  = local.local_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(var.name)
    local-hostname = var.name
  })

  user_data = <<-EOT
  #cloud-config
  hostname: ${var.name}
  package_update: true
  package_upgrade: true
  ${var.write_files}
  ${var.runcmd}
  ssh_pwauth: true
  EOT
}

resource "proxmox_vm_qemu" "vm" {
  agent       = 1
  clone       = var.clone_template
  cores       = var.cores
  cpu         = var.cpu_type
  desc        = local.description
  ipconfig0   = "ip=dhcp"
  memory      = var.memory
  name        = var.name
  onboot      = true
  os_type     = var.os_type
  scsihw      = var.scsihw
  sockets     = 1
  tags        = var.tags
  target_node = var.host_node

  disks {
    ide {
      ide0 {
        cdrom {
          iso = proxmox_cloud_init_disk.cloudinit.id
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          discard    = true
          emulatessd = var.is_SSD
          size       = var.main_disk_size
          storage    = var.storage_location
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  depends_on = [proxmox_cloud_init_disk.cloudinit]
}