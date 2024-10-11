module "aws" {
  source = "../../modules/versions/aws"
}

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }

  backend "s3" {}
}

module "terraform_version" {
  source = "../../modules/versions/terraform"
}

provider "proxmox" {
  pm_api_url = "https://behemoth.fleet.pafable.com:8006/api2/json"
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"

  default_tags {
    tags = {
      code_location = "k8s-platform/terraform/proxmox/k3s-infra"
      managed_by    = "terraform"
      owner         = "pafable"
    }
  }
}