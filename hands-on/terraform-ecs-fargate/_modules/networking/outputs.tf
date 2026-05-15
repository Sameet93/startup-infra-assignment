output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  description = "Security group for the load balancer."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group for ECS tasks."
  value       = aws_security_group.ecs.id
}

output "db_security_group_id" {
  description = "Security group for the database."
  value       = aws_security_group.db.id
}

output "nat_gateway_id" {
  description = "NAT gateway ID."
  value       = aws_nat_gateway.main.id
}
