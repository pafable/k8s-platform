output "parameters" {
  value = { for parameter in aws_ssm_parameter.parameters :
    parameter.name => {
      description = parameter.description
      name        = parameter.name
      type        = parameter.type
      value       = nonsensitive(parameter.value)
    }
  }
}
