output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "vpc_name" {
  value = module.vpc.name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "intra_subnet_ids" {
  value = module.vpc.intra_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}