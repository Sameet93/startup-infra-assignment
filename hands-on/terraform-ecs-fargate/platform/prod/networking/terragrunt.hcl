include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../..//stacks/networking"
}

inputs = {
  name_prefix         = "${local.env.locals.project_name}-${local.env.locals.environment}"
  vpc_cidr            = local.env.locals.vpc_cidr
  public_subnet_count = local.env.locals.public_subnet_count
  private_subnet_count = local.env.locals.private_subnet_count
  app_port            = local.env.locals.app_port
}
