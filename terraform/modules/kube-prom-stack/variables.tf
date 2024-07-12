variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "monitoring"
}
variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "61.3.1"
}

variable "grafana_image_repo" {
  description = "Grafana image repository"
  type        = string
  default     = "grafana/grafana-enterprise"
}

variable "grafana_image_tag" {
  description = "Grafana image tag"
  type        = string
  default     = "11.1.0"
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