variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "15.5.5"
}

variable "admin_email" {
  description = "The email address of the admin user"
  type        = string
}

variable "namespace" {
  description = "The namespace to install the Helm chart into"
  type        = string
  default     = "postgresql"
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