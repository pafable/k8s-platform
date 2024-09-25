locals {
  local_storage_pool = "local"
  creation_date      = timestamp()
  description        = "${var.desc}. Instance launched on ${local.creation_date}"
}

resource "proxmox_cloud_init_disk" "cloudinit" {
  name     = "${var.name}-cloudinit"
  pve_node = var.pve_node
  storage  = local.local_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(var.name)
    local-hostname = var.name
  })

  user_data = <<-EOT
  #cloud-config
  ssh_pwauth: true
  package_update: true
  package_upgrade: true
  packages:
    - lynx
  runcmd:
    - ${var.runcmd}
    - "firewall-cmd --add-port=6443/tcp --permanent && firewall-cmd --reload"
  write_files:
    - path: /home/packer/instance_creation_date
      owner: nobody:nobody
      content: |
        Name: ${var.name}
        Created: ${local.creation_date}
        image_template: ${var.clone}
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
  desc        = local.description
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