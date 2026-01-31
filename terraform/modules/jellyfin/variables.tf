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

variable "cpu_request" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "jellyfin-test.home.pafable.com"
}

variable "gateway_class_name" {
  description = "Gateway class name"
  type        = string
  default     = "door"
}

variable "memory_request" {
  description = "Memory request"
  type        = string
  default     = "1.0Gi"
}

variable "namespace" {
  description = "Jellyfin namespace"
  type        = string
  default     = "jellyfin"
}

variable "node_name" {
  description = "Kubernetes node to deploy on"
  type        = string
  default     = "worker-03"
}

variable "owner" {
  description = "App owner"
  type        = string
  default     = "devops"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}