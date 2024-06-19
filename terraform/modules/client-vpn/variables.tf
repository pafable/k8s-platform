variable "client_banner" {
  description = "Client banner"
  type        = string
}

variable "client_cidr_block" {
  description = "Client CIDR block"
  type        = string
}

variable "enable_split_tunnel" {
  description = "Enable split tunneling"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name"
  type        = string
}

variable "destination_cidr" {
  description = "Destination CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "dns_server" {
  description = "DNS server"
  type        = string
}


variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "server_private_key" {
  description = "private key for vpn server certificate"
  type        = string
  sensitive   = true
}

variable "server_cert" {
  description = "server certificate"
  type        = string
  sensitive   = true

}

variable "ca_cert" {
  description = "CA certificate"
  type        = string
  sensitive   = true
}