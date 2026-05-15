output "db_instance_endpoint" {
  description = "Database endpoint when created."
  value       = var.create ? aws_db_instance.postgres[0].address : null
}
