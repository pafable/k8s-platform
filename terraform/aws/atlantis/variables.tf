variable "atlantis_domain" {
  description = "Domain name for atlantis"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "ghost_domain" {
  description = "Domain for ghost"
  type        = string
}

variable "github_repo" {
  description = "Github repository"
  type        = string
}

variable "github_token" {
  description = "Github token"
  sensitive   = true
  type        = string
}

variable "github_user" {
  description = "Github username"
  type        = string
}

variable "github_webhook_secret" {
  description = "Github webhook secret"
  sensitive   = true
  type        = string
}

variable "github_webhook_events" {
  description = "Github webhook events"
  type        = list(string)
  default     = ["issue_comment", "push", "pull_request", "pull_request_review"]
}

variable "ngrok_endpoint" {
  description = "Ngrok endpoint"
  type        = string
}

variable "repo_allowlist" {
  description = "Atlantis repo allowlist"
  type        = string
}