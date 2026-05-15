include "root" {
  path = find_in_parent_folders()
}

locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  name_prefix      = "${local.env.locals.project_name}-${local.env.locals.environment}"
  use_mock_outputs = get_env("TG_USE_MOCK_OUTPUTS", "false") == "true" || contains(["init", "validate", "plan"], get_terraform_command())
}

terraform {
  source = "../../..//stacks/rds"
}

dependency "networking" {
  config_path  = "../networking"
  skip_outputs = local.use_mock_outputs

  mock_outputs = {
    private_subnet_ids   = ["subnet-100001", "subnet-100002"]
    db_security_group_id = "sg-000003"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  create              = local.env.locals.enable_rds
  name_prefix         = local.name_prefix
  subnet_ids          = dependency.networking.outputs.private_subnet_ids
  security_group_ids  = [dependency.networking.outputs.db_security_group_id]
  db_name             = local.env.locals.db_name
  username            = local.env.locals.db_username
  password            = local.env.locals.db_password
  publicly_accessible = false
}
