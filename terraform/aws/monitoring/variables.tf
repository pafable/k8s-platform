variable "aws_region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "branch" {
  description = "Git branch to deploy"
  type        = string
}

variable "commit" {
  description = "Git commit to deploy"
  type        = string
}