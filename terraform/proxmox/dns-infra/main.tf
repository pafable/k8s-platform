locals {
  cmd = {
    runcmd = [
      "echo hi > /tmp/hi.txt"
    ]
  }

  default_tag = "dns"
  pm_node     = "leviathan"

  wr_files = {
    write_files = [
      {
        path    = "/home/${var.ssh_username}/instance_creation_date"
        owner   = "nobody:nobody"
        content = <<-EOT
          Name: ${var.name}
          Created: ${timestamp()}
          clone_template: ${var.clone_template}
        EOT
      }
    ]
  }
}

module "dns_vm" {
  source              = "../../modules/proxmox-vm"
  clone_template      = var.clone_template
  cloud_init_pve_node = local.pm_node
  host_node           = local.pm_node
  memory              = 8192
  name                = var.name
  runcmd              = yamlencode(local.cmd)
  tags                = local.default_tag
  write_files         = yamlencode(local.wr_files)
}