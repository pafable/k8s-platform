variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "15.5.5"
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

variable "pgadmin_email" {
  description = "The email address of the admin user"
  type        = string
  default     = "admin@example.com"
}

variable "pgadmin_image" {
  description = "The image to use for pgAdmin"
  type        = string
  default     = "dpage/pgadmin4:8.9"
}

variable "pgadmin_password" {
  description = "The password for the pgAdmin user"
  type        = string
  default     = ""
}