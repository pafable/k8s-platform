variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform"
}

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "8.3.1"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://charts.gitlab.io/"
}

variable "ou" {
  description = "Organizational Unit"
  type        = string
  default     = "devops"
}

variable "owner" {
  description = "Owner of resource"
  type        = string
  default     = "devops"
}

variable "timeout" {
  description = "Timeout for the resource"
  type        = number
  default     = 500
}

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "Etc/UTC"
}