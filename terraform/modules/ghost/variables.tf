variable "app_name" {
  description = "App name"
  type        = string
  default     = "ghost"
}

variable "app_version" {
  description = "Application version"
  type = object({
    version = string
  })
  default = { version = "blue" }
}

variable "namespace" {
  description = "Namespace to deploy to"
  type        = string
  default     = "ghost"
}

variable "replicas" {
  description = "Replica count"
  type        = number
  default     = 1
}