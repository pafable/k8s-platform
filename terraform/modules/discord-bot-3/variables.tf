variable "app_name" {
  description = "App name"
  type        = string
  default     = "discord-bot-3"
}

variable "app_version" {
  description = "Application version"
  type = object({
    version = string
  })
  default = { version = "blue" }
}

variable "aws_access_key_id" {
  description = "AWS access key id"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
}

variable "discord_id" {
  description = "Discord server id"
  type        = string
}

variable "discord_token" {
  description = "Discord token"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy to"
  type        = string
  default     = "discord-bot-3"
}

variable "replicas" {
  description = "Replica count"
  type        = number
  default     = 1
}