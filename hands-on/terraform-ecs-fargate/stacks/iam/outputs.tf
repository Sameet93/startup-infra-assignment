output "ecs_task_execution_role_arn" {
  description = "Execution role ARN for ECS tasks."
  value       = module.iam.ecs_task_execution_role_arn
}
