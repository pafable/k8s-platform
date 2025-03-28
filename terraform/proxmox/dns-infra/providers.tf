module "aws" {
  source = "../../modules/versions/aws"
}

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }

  backend "s3" {}
}

module "terraform_version" {
  source = "../../modules/versions/terraform"
}

provider "proxmox" {
  pm_api_url      = "https://${data.aws_ssm_parameter.main_proxmox_node.value}:8006/api2/json"
  pm_tls_insecure = true
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"

  default_tags {
    tags = {
      code_location = "k8s-platform/terraform/proxmox/dns-infra"
      managed_by    = "terraform"
      owner         = "pafable"
    }
  }
}