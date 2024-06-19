# This needs to be defined in the sub/child module otherwise terraform will try to use hashicorp/grafana provider which does not exist.
terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 3.0.0"
    }
  }
}

provider "grafana" {
  url                  = var.grafana_domain[terraform.workspace]
  auth                 = var.svc_acct_token
  insecure_skip_verify = true
}