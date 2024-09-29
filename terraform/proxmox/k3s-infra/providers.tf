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
  pm_api_url = "https://horde.home.pafable.com:8006/api2/json"
}