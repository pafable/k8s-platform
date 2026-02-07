variable "app_version" {
  description = "Application version"
  type = object({
    version = string
  })
  default = { version = "blue" }
}

variable "container_hostname" {
  description = "jellyfin container hostname"
  type        = string
  default     = "tentacool"
}

variable "container_image" {
  description = "jellyfin container image"
  type        = string
  default     = "docker.io/jellyfin/jellyfin:10.11.6"
}

variable "cpu_request" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "domain" {
  description = "Domain"
  type        = string
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

variable "nfs_ipv4" {
  description = "IP address of NFS server for storage backend"
  type        = string
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

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
  default     = "nfs"
}

variable "self_signed_ca_name" {
  description = "Self signed CA"
  type        = string
  default     = "self-signed-ca-cluster-issuer"
}