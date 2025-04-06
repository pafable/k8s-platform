locals {
  default_tag   = "rpm-srv"
  pm_node       = "leviathan"
  creation_date = timestamp()
  # rpm_dir       = "/srv/pafable/repo"
  nexus_image   = "docker.io/sonatype/nexus3:3.79.0"
  nexus_nfs_mount = "/mnt/fs/nexus:/nexus-data"

  resize_disk_cmd = [
    "parted -s /dev/sda resizepart 2 ${var.disk_size}B",
    "pvresize /dev/sda2",
    "lvextend --resizefs -l +100%FREE /dev/rl/root"
  ]

  firewall_cmd = [
    "firewall-cmd --add-port=80/tcp --permanent",
    "firewall-cmd --add-port=443/tcp --permanent",
    "firewall-cmd --reload"
  ]

  podman_cmd = [
    "podman run --name nexus --hostname nexus --detach --publish 8081:8081 --publish 8085:8085 --volume ${local.nexus_nfs_mount}:Z --replace ${local.nexus_image}"
  ]

  nginx_cmd = [
    "setsebool httpd_can_network_connect 1 -P", # to fix the 503 error on nginx
    "curl -o"
  ]

  cmds = {
    rpm_srv = {
      runcmd = concat(
        local.resize_disk_cmd,
        local.firewall_cmd,
        local.podman_cmd,
        [
          "echo hi > /tmp/hi.txt",
          ## keeping these here as an example on how to use reposync
          # "mkdir -p ${local.rpm_dir}",
          # "dnf reposync -p ${local.rpm_dir} --newest-only",
          # "createrepo ${local.rpm_dir}",
          # "python -m http.server 80 --directory ${local.rpm_dir} > /dev/null 2>&1 &",
        ]
      )
    }
  }

  creation_files = {
    rpm_srv = {
      path    = "/home/${var.ssh_username}/instance_creation_date"
      owner   = "nobody:nobody"
      content = <<-EOT
        Name: ${var.host_name}
        Created: ${local.creation_date}
        clone_template: ${var.clone_template}
      EOT
    }
  }

  install_packages = {
    packages = [
      "createrepo",
      "htop",
      "nginx",
      "podman"
    ]
  }

  wr_files = {
    rpm_srv = {
      write_files = [
        local.creation_files.rpm_srv
      ]
    }
  }

  user_datas = {
    rpm_srv = {
      user_data = <<-EOT
        #cloud-config
        hostname: ${var.host_name}
        package_update: true
        ${yamlencode(local.install_packages)}
        package_upgrade: true
        ${yamlencode(local.wr_files.rpm_srv)} # files need to exist on instance before running commands
        ssh_pwauth: true
        ${yamlencode(local.cmds.rpm_srv)}
      EOT
    }
  }
}

module "rpm_srv" {
  source         = "../../modules/proxmox-vm"
  clone_template = var.clone_template
  host_node      = local.pm_node
  memory         = 8192
  name           = var.host_name
  main_disk_size = var.disk_size
  tags           = local.default_tag
  user_data      = local.user_datas.rpm_srv.user_data
}