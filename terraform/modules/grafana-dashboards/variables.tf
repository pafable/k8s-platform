variable "grafana_domain" {
  description = "Grafana domain"
  type = object({
    dev  = string
    prod = string
  })
  default = {
    dev  = "https://grafana.local/"
    prod = "https://grafana.prod/"
  }
}

variable "svc_acct_token" {
  description = "Service account token for Grafana"
  type        = string
}