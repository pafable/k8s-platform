variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "3.13.0"
}

variable "is_cloud" {
  description = "Whether the cluster is local"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "The namespace to install the Helm chart into"
  type        = string
  default     = "kube-system"
}

variable "owner" {
  description = "Owner of resources"
  type        = string
  default     = "devops"
}