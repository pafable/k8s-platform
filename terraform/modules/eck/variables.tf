variable "helm_chart_version_eck_op" {
  description = "helm chart version"
  type        = string
  default     = "2.14.0"
}

variable "helm_chart_version_eck_stack" {
  description = "helm chart version"
  type        = string
  default     = "0.12.0"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://helm.elastic.co"
}

variable "namespace" {
  description = "Namespace"
  type        = string
  default     = "elastic"
}

variable "owner" {
  description = "Owner of resource"
  type        = string
  default     = "devops"
}
