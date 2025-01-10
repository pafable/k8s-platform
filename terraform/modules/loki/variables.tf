variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform/terraform/apps"
}

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "2.10.2"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "owner" {
  description = "Owner of resource"
  type        = string
  default     = "devops"
}

variable "timeout" {
  description = "Timeout for the resource"
  type        = number
  default     = 300
}
