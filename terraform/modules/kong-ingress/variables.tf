variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "2.38.0"
}

variable "namespace" {
  description = "The namespace to install the Helm chart"
  type        = string
  default     = "kong-ingress"
}

variable "timeout" {
  description = "Helm timeout"
  type        = number
  default     = 300
}