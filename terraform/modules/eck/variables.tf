variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "2.14.0"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://helm.elastic.co"
}

variable "owner" {
  description = "Owner of resource"
  type        = string
  default     = "devops"
}
