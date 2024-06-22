variable "helm_chart_version" {
  description = "The version of the Helm chart to deploy"
  type        = string
  default     = "5.20.0"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}