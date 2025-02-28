locals {
  local_storage_pool = "local"
  creation_date      = timestamp() # timestamps are in Zulu aka UTC time
  description        = "${var.desc}. Instance launched on ${local.creation_date}"
}

resource "proxmox_cloud_init_disk" "cloudinit" {
  name     = "${var.name}-cloudinit"
  pve_node = var.host_node
  storage  = local.local_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(var.name)
    local-hostname = var.name
  })

  user_data = var.user_data
}

resource "proxmox_vm_qemu" "vm" {
  agent       = 1
  clone       = var.clone_template
  cores       = var.cores
  cpu_type    = var.cpu_type
  desc        = local.description
  ipconfig0   = "ip=dhcp"
  memory      = var.memory
  name        = var.name
  onboot      = true
  os_type     = var.os_type
  scsihw      = var.scsihw
  skip_ipv6   = true
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
    bridge = "vmbr0"
    id     = 0
    model  = "virtio"
  }

  depends_on = [proxmox_cloud_init_disk.cloudinit]
}