output "db_instance_endpoint" {
  description = "Database endpoint when created."
  value       = module.rds.db_instance_endpoint
}
