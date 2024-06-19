variable "branch" {
  description = "The branch of the code"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}