variable "code" {
  description = "Code location"
  type        = string
  default     = "k8s-platform"
}

variable "helm_chart_version" {
  description = "helm chart version"
  type        = string
  default     = "5.4.3"
}

variable "helm_repo" {
  description = "Helm repo url"
  type        = string
  default     = "https://charts.jenkins.io"
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