variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "aws_region" {
  description = "AWS region for logging configuration."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB target group."
  type        = string
}

variable "alb_subnet_ids" {
  description = "Public subnets used by the ALB."
  type        = list(string)
}

variable "ecs_subnet_ids" {
  description = "Private subnets used by ECS tasks."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group attached to the ALB."
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group attached to ECS tasks."
  type        = string
}

variable "execution_role_arn" {
  description = "Execution role ARN for ECS tasks."
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group used by the task definition."
  type        = string
}

variable "container_image" {
  description = "Container image for the ECS service."
  type        = string
}

variable "container_cpu" {
  description = "Fargate task CPU units."
  type        = number
}

variable "container_memory" {
  description = "Fargate task memory in MiB."
  type        = number
}

variable "desired_count" {
  description = "Desired ECS task count."
  type        = number
}

variable "min_capacity" {
  description = "Minimum autoscaling capacity."
  type        = number
}

variable "max_capacity" {
  description = "Maximum autoscaling capacity."
  type        = number
}

variable "app_port" {
  description = "Application port exposed by the container."
  type        = number
}

variable "health_check_path" {
  description = "ALB health check path."
  type        = string
  default     = "/"
}
