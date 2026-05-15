output "vpc_id" {
  description = "VPC ID."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.networking.private_subnet_ids
}

output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = module.networking.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "ECS security group ID."
  value       = module.networking.ecs_security_group_id
}

output "db_security_group_id" {
  description = "Database security group ID."
  value       = module.networking.db_security_group_id
}

output "nat_gateway_id" {
  description = "NAT gateway ID."
  value       = module.networking.nat_gateway_id
}
