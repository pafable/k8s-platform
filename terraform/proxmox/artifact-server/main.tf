locals {
  default_tag        = "nexus"
  pm_node            = "behemoth"
  creation_date      = timestamp()
  nexus_service_path = "/usr/lib/systemd/system/nexus.service"
  nexus_dir          = "/mnt/fs/${local.default_tag}"
  nfs_server         = "kraken.fleet.pafable.com"
  logical_volume     = "/dev/mapper/almalinux-root"
  partition          = "/dev/sda"
  # rpm_dir       = "/srv/pafable/repo"

  resize_disk_cmd = [
    "parted -s ${local.partition} resizepart 2 100%",
    "pvresize ${local.partition}2",
    "lvextend --resizefs -l +100%FREE ${local.logical_volume}"
  ]

  firewall_cmd = [
    "firewall-cmd --add-port=80/tcp --permanent",
    "firewall-cmd --add-port=443/tcp --permanent",
    "firewall-cmd --reload"
  ]

  nexus_cmd = [
    "curl https://raw.githubusercontent.com/pafable/k8s-platform/refs/heads/artifact-repo/terraform/proxmox/artifact-server/nexus.service -o ${local.nexus_service_path}",
    "systemctl enable ${local.default_tag} --now"
  ]

  # nginx_cmd = [
  #   "setsebool httpd_can_network_connect 1 -P", # to fix the 503 error on nginx
  #   "curl -o https://raw.githubusercontent.com/pafable/k8s-platform/refs/heads/artifact-repo/terraform/proxmox/rpm-server/nexus.conf /etc/nginx/conf.d/nexus.conf",
  #   "systemctl enable nginx --now"
  # ]

  cmds = {
    artifact_srv = {
      runcmd = concat(
        local.resize_disk_cmd,
        local.firewall_cmd,
        # local.nginx_cmd,
        [
          "echo hi > /tmp/hi.txt",
          ## keeping these here as an example on how to use reposync
          # "mkdir -p ${local.rpm_dir}",
          # "dnf reposync -p ${local.rpm_dir} --newest-only",
          # "createrepo ${local.rpm_dir}",
          # "python -m http.server 80 --directory ${local.rpm_dir} > /dev/null 2>&1 &",
          "mkdir -p ${local.nexus_dir}",
          "echo kraken.${var.fleet_domain}:/volume2/fs/nexus /mnt/fs/nexus  nfs  defaults   0   0 >> /etc/fstab",
          "systemctl daemon-reload",
          "mount -a",
        ],
        local.nexus_cmd
      )
    }
  }

  creation_files = {
    artifact_srv = {
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
      "dnf-utils",
      "htop",
      "nfs-utils",
      "nginx",
      "podman"
    ]
  }

  wr_files = {
    artifact_srv = {
      write_files = [
        local.creation_files.artifact_srv
      ]
    }
  }

  user_datas = {
    artifact_srv = {
      user_data = <<-EOT
        #cloud-config
        hostname: ${var.host_name}
        package_update: true
        ${yamlencode(local.install_packages)}
        package_upgrade: true
        ${yamlencode(local.wr_files.artifact_srv)} # files need to exist on instance before running commands
        ssh_pwauth: true
        ${yamlencode(local.cmds.artifact_srv)}
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
  user_data      = local.user_datas.artifact_srv.user_data
}