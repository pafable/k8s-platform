locals {
  domain_credentials = [
    {
      # Do NOT set this in prod.
      # use AWS Secret manager credential manager as the source for creds in prod
      # https://plugins.jenkins.io/aws-secrets-manager-credentials-provider/
      credentials = [
        {
          usernamePassword = {
            description = "docker hub credentials"
            id          = "docker-hub-creds"
            password    = sensitive(var.docker_hub_password)
            scope       = "GLOBAL"
            username    = var.docker_hub_username
          }
        },
        {
          usernamePassword = {
            description = "Proxmox API creds"
            id          = "proxmox-api-creds"
            password    = sensitive(var.proxmox_token_secret)
            scope       = "GLOBAL"
            username    = sensitive(var.proxmox_token_id)
          }
        },
        {
          usernamePassword = {
            description = "Test ssh creds for packer"
            id          = "packer-test-ssh-creds"
            password    = sensitive(var.packer_ssh_password)
            scope       = "GLOBAL"
            username    = sensitive(var.packer_ssh_username)
          }
        },
        {
          aws = {
            accessKey   = sensitive(var.aws_dev_deployer_access_key)
            description = "AWS credentials for dev account"
            id          = "aws-dev-deployer-creds"
            scope       = "GLOBAL"
            secretKey   = sensitive(var.aws_dev_deployer_secret_key)
          }
        },
        {
          file = {
            description = "Kubeconfig for k3s"
            fileName    = "k3s-config"
            id          = "hive-fleet-k3s-config"
            scope       = "GLOBAL"
            secretBytes = sensitive(var.k3s_config_file)
          }
        },
        {
          string = {
            description = "github token"
            id          = "github-token"
            scope       = "GLOBAL"
            secret      = var.jenkins_github_token
          }
        },
        {
          string = {
            description = "http server for packer"
            id          = "http-server"
            scope       = "GLOBAL"
            secret      = var.http_server
          }
        }
      ]
    }
  ]
}