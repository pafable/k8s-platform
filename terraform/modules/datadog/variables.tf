variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
}

variable "datadog_app_key" {
  description = "Datadog APP key"
  type        = string
}

variable "datadog_helm_version" {
  description = "Datadog Operator helm version"
  type        = string
  default     = "1.7.0"
}

variable "db_host" {
  description = "The database host"
  type        = string
  default     = "localhost"
}

variable "db_name" {
  description = "The database name"
  type        = string
  default     = "postgres"

}

variable "db_password" {
  description = "The database password"
  type        = string
  default     = "postgres"


}

variable "db_user" {
  description = "The database user"
  type        = string
  default     = "postgres"

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