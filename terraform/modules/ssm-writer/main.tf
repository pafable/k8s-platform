resource "aws_ssm_parameter" "parameters" {
  for_each = { for v in var.parameters :
    v.name => {
      value       = v.value
      description = v.description
    }
  }

  description = each.value.description
  name        = each.key
  overwrite   = true
  type        = "String"
  value       = each.value.value
}
