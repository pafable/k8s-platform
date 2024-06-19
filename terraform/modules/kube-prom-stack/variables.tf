variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "monitoring"
}
variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "58.7.2"
}

variable "is_cloud" {
  description = "Whether the cluster is local"
  type        = bool
  default     = true
}

variable "ou" {
  description = "The organizational unit"
  type        = string
  default     = "devops"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "devops"
}