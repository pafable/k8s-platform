variable "chart_version" {
  description = "podinfo helm version"
  type        = string
  default     = "6.17.0"
}

variable "app_repo" {
  description = "podinfo app repo"
  type        = string
  default     = "https://github.com/pafable/k8s-platform.git"
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "home.pafable.com"
}

variable "gateway_class_name" {
  description = "Gateway class name"
  type        = string
  default     = "door"
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

variable "replicas" {
  description = "Number of replicas for the podinfo deployment"
  type        = number
  default     = 1
}