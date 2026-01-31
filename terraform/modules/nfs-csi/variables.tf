variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "4.12.1"
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