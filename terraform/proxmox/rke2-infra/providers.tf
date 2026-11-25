terraform {
  backend "s3" {}
}

module "aws" {
  source = "../../modules/versions/aws"
}

module "proxmox_version" {
  source = "../../modules/versions/proxmox-bpg"
}

module "terraform_version" {
  source = "../../modules/versions/terraform"
}

provider "proxmox" {
  endpoint = "https://behemoth.fleet.pafable.com:8006/"
  insecure = true
}

provider "aws" {
  alias  = "parameters"
  region = "us-east-1"

  default_tags {
    tags = {
      code_location = "k8s-platform/terraform/proxmox/rke2-infra"
      managed_by    = "terraform"
      owner         = "pafable"
    }
  }
}