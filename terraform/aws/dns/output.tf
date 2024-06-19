output "dns_records" {
  description = "The FQDN of the DNS records"
  value       = { for k, v in aws_route53_record.r53_record : k => v.fqdn }
}