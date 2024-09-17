locals {
  local_storage_pool = "local"
}

resource "proxmox_vm_qemu" "vm" {
  clone       = var.clone
  cores       = var.cores
  cpu         = var.cpu_type
  desc        = var.desc
  ipconfig0   = "ip=dhcp"
  memory      = var.memory
  name        = var.name
  os_type     = var.os_type
  scsihw      = var.scsihw
  sockets     = 1
  tags        = var.tags
  target_node = var.host_node

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "${local.local_storage_pool}:iso/${var.iso}"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size    = var.main_disk_size
          storage = var.storage_location
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}