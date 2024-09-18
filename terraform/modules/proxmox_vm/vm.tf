locals {
  local_storage_pool = "local"
  pve_node           = "horde"
}

resource "proxmox_cloud_init_disk" "cloudinit" {
  name     = "${var.name}-cloudinit"
  pve_node = local.pve_node
  storage  = local.local_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(var.name)
    local-hostname = var.name
  })

  user_data = <<-EOT
  #cloud-config
  ssh_pwauth: True
  EOT

  #   network_config = yamlencode({
  #     version = 1
  #     config = [{
  #       type = "physical"
  #       name = "eth0"
  #       subnets = [{
  #         type    = "static"
  #         address = "192.168.1.100/24"
  #         gateway = "192.168.1.1"
  #         dns_nameservers = [
  #           "1.1.1.1",
  #           "8.8.8.8"
  #         ]
  #       }]
  #     }]
  #   })
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
      ide0 {
        cdrom {
          iso = proxmox_cloud_init_disk.cloudinit.id
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          emulatessd = var.isSSD
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
}