variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "2.40.0"
}

variable "namespace" {
  description = "The namespace to install the Helm chart"
  type        = string
  default     = "kong-ingress"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}

variable "timeout" {
  description = "Helm timeout"
  type        = number
  default     = 300
}