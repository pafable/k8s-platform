variable "envoy_gw_helm_chart_version" {
  description = "Envoy gateway helm chart version"
  type        = string
  default     = "0.0.0-latest"
}

variable "app_repo" {
  description = "App repo"
  type        = string
  default     = "oci://docker.io/envoyproxy"
}

variable "gateway_chart_name" {
  description = "Chart name"
  type        = string
  default     = "gateway-helm"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}