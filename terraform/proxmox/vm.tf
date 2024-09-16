locals {
  cores              = 2
  host_node          = "horde"
  local_storage_pool = "local"
  main_disk_size     = "100G"
  memory             = 2048
  name               = "gru-01"
  rocky_iso          = "${local.local_storage_pool}:iso/Rocky-9.4-x86_64-boot.iso"
}

resource "proxmox_vm_qemu" "k3s_master" {
  cores       = local.cores
  cpu         = "x86-64-v2-AES"
  desc        = "created and managed by terraform"
  ipconfig0   = "ip=dhcp"
  memory      = local.memory
  name        = local.name
  os_type     = "Linux 6.x - 2.6 Kernel"
  scsihw      = "virtio-scsi-single"
  tags        = "phil,test"
  target_node = local.host_node

  disks {
    ide {
      ide2 {
        cdrom {
          iso = local.rocky_iso
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size    = local.main_disk_size
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}