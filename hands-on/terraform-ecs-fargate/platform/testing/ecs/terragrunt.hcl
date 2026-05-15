include "root" {
  path = find_in_parent_folders()
}

locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  name_prefix      = "${local.env.locals.project_name}-${local.env.locals.environment}"
  use_mock_outputs = get_env("TG_USE_MOCK_OUTPUTS", "false") == "true"
}

terraform {
  source = "../../..//stacks/ecs"
}

dependency "networking" {
  config_path  = "../networking"
  skip_outputs = get_env("TG_USE_MOCK_OUTPUTS", "false") == "true"

  mock_outputs = {
    vpc_id                = "vpc-000000"
    public_subnet_ids     = ["subnet-000001", "subnet-000002"]
    private_subnet_ids    = ["subnet-100001", "subnet-100002"]
    alb_security_group_id = "sg-000001"
    ecs_security_group_id = "sg-000002"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "iam" {
  config_path  = "../iam"
  skip_outputs = get_env("TG_USE_MOCK_OUTPUTS", "false") == "true"

  mock_outputs = {
    ecs_task_execution_role_arn = "arn:aws:iam::123456789012:role/mock-ecs-execution"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "cloudwatch" {
  config_path  = "../cloudwatch"
  skip_outputs = get_env("TG_USE_MOCK_OUTPUTS", "false") == "true"

  mock_outputs = {
    log_group_name = "/ecs/mock-testing"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  name_prefix           = local.name_prefix
  aws_region            = local.env.locals.aws_region
  vpc_id                = dependency.networking.outputs.vpc_id
  alb_subnet_ids        = dependency.networking.outputs.public_subnet_ids
  ecs_subnet_ids        = dependency.networking.outputs.private_subnet_ids
  alb_security_group_id = dependency.networking.outputs.alb_security_group_id
  ecs_security_group_id = dependency.networking.outputs.ecs_security_group_id
  execution_role_arn    = dependency.iam.outputs.ecs_task_execution_role_arn
  log_group_name        = dependency.cloudwatch.outputs.log_group_name
  container_image       = local.env.locals.container_image
  container_cpu         = local.env.locals.container_cpu
  container_memory      = local.env.locals.container_memory
  desired_count         = local.env.locals.desired_count
  min_capacity          = local.env.locals.min_capacity
  max_capacity          = local.env.locals.max_capacity
  app_port              = local.env.locals.app_port
  health_check_path     = local.env.locals.health_check_path
}
