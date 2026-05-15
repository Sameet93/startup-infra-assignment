module "ecs" {
  source = "../../_modules/ecs"

  name_prefix           = var.name_prefix
  aws_region            = var.aws_region
  vpc_id                = var.vpc_id
  alb_subnet_ids        = var.alb_subnet_ids
  ecs_subnet_ids        = var.ecs_subnet_ids
  alb_security_group_id = var.alb_security_group_id
  ecs_security_group_id = var.ecs_security_group_id
  execution_role_arn    = var.execution_role_arn
  log_group_name        = var.log_group_name
  container_image       = var.container_image
  container_cpu         = var.container_cpu
  container_memory      = var.container_memory
  desired_count         = var.desired_count
  min_capacity          = var.min_capacity
  max_capacity          = var.max_capacity
  app_port              = var.app_port
  health_check_path     = var.health_check_path
}
