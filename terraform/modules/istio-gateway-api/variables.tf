variable "istio_helm_chart_version" {
  description = "Istio base helm chart version"
  type        = string
  default     = "1.31.3"
}

variable "app_repo" {
  description = "App repo"
  type        = string
  default     = "https://blob.istio.io/istio-release/charts"
}

variable "base_chart_name" {
  description = "Chart name for istio base"
  type        = string
  default     = "base"
}

variable "istiod_chart_name" {
  description = "Chart name for istiod"
  type        = string
  default     = "istiod"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}