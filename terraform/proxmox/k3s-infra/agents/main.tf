locals {
  default_tags = "k3s"
  host_name    = "hive-ship"
  current_time = timestamp()

  # home network
  home_network = "192.168.109.0/24"

  k3s_nodes = {
    agent_1 = {
      name     = "${local.host_name}-agent-01"
      node     = "kraken"
      template = "orc-tmpl-1"
    }

    agent_2 = {
      name     = "${local.host_name}-agent-02"
      node     = "leviathan"
      template = "orc-tmpl-1"
    }
  }

  creation_files = {
    agent_1 = {
      path    = "/home/${var.ssh_username}/instance_creation_date"
      owner   = "nobody:nobody"
      content = <<-EOT
        name: ${local.k3s_nodes.agent_1.name}
        created: ${local.current_time}
        clone_template: ${local.k3s_nodes.agent_1.template}
      EOT
    }

    agent_2 = {
      path    = "/home/${var.ssh_username}/instance_creation_date"
      owner   = "nobody:nobody"
      content = <<-EOT
        name: ${local.k3s_nodes.agent_2.name}
        created: ${local.current_time}
        clone_template: ${local.k3s_nodes.agent_2.template}
      EOT
    }
  }

  base_runcmd = [
    "firewall-cmd --add-port=443/tcp --permanent",
    "firewall-cmd --add-port=6443/tcp --permanent",
    "firewall-cmd --add-port=10250/tcp --permanent",
    "firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 --permanent",          # pods
    "firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 --permanent",          # services
    "firewall-cmd --permanent --zone=trusted --add-source=${local.home_network} --permanent", # home network
    "firewall-cmd --reload"
  ]

  cmds = {
    agent = {
      runcmd = concat(
        # order matters because ports need to be open before running script
        local.base_runcmd,
        [
          "curl -sfL https://get.k3s.io | K3S_URL=https://${data.aws_ssm_parameter.k3s_controller_ipv4.value}:6443 K3S_TOKEN=${data.aws_ssm_parameter.k3s_join_token.value} sh -",
        ]
      )
    }
  }

  base_file = {
    path    = "/home/${var.ssh_username}/k3s_storage_class.yaml"
    content = <<-EOT
      apiVersion: storage.k8s.io/v1
      kind: StorageClass
      metadata:
      name: ${local.host_name}-sc
      provisioner: rancher.io/local-path
      reclaimPolicy: Delete
      volumeBindingMode: Immediate
    EOT
  }

  wr_files = {
    agent_1 = {
      write_files = [
        local.base_file,
        local.creation_files.agent_1
      ]
    }

    agent_2 = {
      write_files = [
        local.base_file,
        local.creation_files.agent_2
      ]
    }
  }

  user_datas = {
    agent_1 = {
      user_data = <<-EOT
        #cloud-config
        hostname: ${local.k3s_nodes.agent_1.name}
        package_update: true
        package_upgrade: true
        ${yamlencode(local.wr_files.agent_1)} # files need to exist on instance before running commands
        ssh_pwauth: true
        ${yamlencode(local.cmds.agent)}
      EOT
    }

    agent_2 = {
      user_data = <<-EOT
        #cloud-config
        hostname: ${local.k3s_nodes.agent_2.name}
        package_update: true
        package_upgrade: true
        ${yamlencode(local.wr_files.agent_2)} # files need to exist on instance before running commands
        ssh_pwauth: true
        ${yamlencode(local.cmds.agent)}
      EOT
    }
  }
}

module "k3s_agent1" {
  source         = "../../../modules/proxmox-vm"
  clone_template = local.k3s_nodes.agent_1.template
  host_node      = local.k3s_nodes.agent_1.node
  memory         = 16384
  name           = local.k3s_nodes.agent_1.name
  tags           = local.default_tags
  user_data      = local.user_datas.agent_1.user_data
}

module "k3s_agent_2" {
  source         = "../../../modules/proxmox-vm"
  clone_template = local.k3s_nodes.agent_2.template
  host_node      = local.k3s_nodes.agent_2.node
  memory         = 16384
  name           = local.k3s_nodes.agent_2.name
  tags           = local.default_tags
  user_data      = local.user_datas.agent_2.user_data
}