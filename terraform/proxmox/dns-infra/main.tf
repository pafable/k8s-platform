locals {
  default_tag   = "dns"
  pm_node       = "behemoth"
  creation_date = timestamp()

  cmds = {
    dns_server = {
      runcmd = [
        "/bin/bash /opt/lab-dns/01-init.sh"
      ]
    }
  }

  creation_files = {
    dns_server = {
      path    = "/home/${var.ssh_username}/instance_creation_date"
      owner   = "nobody:nobody"
      content = <<-EOT
        Name: ${var.host_name}
        Created: ${local.creation_date}
        clone_template: ${var.clone_template}
      EOT
    }
  }

  wr_files = {
    dns_server = {
      write_files = [
        local.creation_files.dns_server
      ]
    }
  }

  user_datas = {
    dns_server = {
      user_data = <<-EOT
        #cloud-config
        hostname: ${var.host_name}
        packages:
          - podman-compose
        package_update: true
        package_upgrade: true
        ${yamlencode(local.wr_files.dns_server)} # files need to exist on instance before running commands
        ssh_pwauth: true
        ${yamlencode(local.cmds.dns_server)}
      EOT
    }
  }
}

module "dns_vm" {
  source         = "../../modules/proxmox-vm"
  clone_template = var.clone_template
  host_node      = local.pm_node
  memory         = 4096
  name           = var.host_name
  tags           = local.default_tag
  user_data      = local.user_datas.dns_server.user_data
}