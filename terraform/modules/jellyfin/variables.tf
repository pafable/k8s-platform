variable "app_version" {
  description = "Application version"
  type = object({
    version = string
  })
  default = { version = "blue" }
}

variable "container_image" {
  description = "jellyfin container image"
  type        = string
  default     = "docker.io/jellyfin/jellyfin:10.11.6"
}

variable "controller_ips" {
  description = "IP addresses of controllers"
  type        = list(string)
  default     = []
}

variable "namespace" {
  description = "Jellyfin namespace"
  type        = string
  default     = "jellyfin"
}

variable "owner" {
  description = "App owner"
  type        = string
  default     = "devops"
}
