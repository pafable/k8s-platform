variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "4.10.1"
}

variable "namespace" {
  description = "The namespace to install the Helm chart into"
  type        = string
  default     = "default"
}