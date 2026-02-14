variable "parameters" {
  description = "params to put in ssm param store"

  type = list(
    object({
      name        = string
      value       = string
      description = string
    })
  )
}
