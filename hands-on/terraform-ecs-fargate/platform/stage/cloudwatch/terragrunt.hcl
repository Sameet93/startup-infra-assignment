include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../..//stacks/cloudwatch"
}

inputs = {
  log_group_name    = "/ecs/${local.env.locals.project_name}-${local.env.locals.environment}"
  retention_in_days = local.env.locals.log_retention_days
}
