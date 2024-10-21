variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "4.11.3"
}

variable "namespace" {
  description = "The namespace to install the Helm chart into"
  type        = string
  default     = "ingress-nginx"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}

variable "timeout" {
  description = "Terraform helm release timeout"
  type        = number
  default     = 500
}