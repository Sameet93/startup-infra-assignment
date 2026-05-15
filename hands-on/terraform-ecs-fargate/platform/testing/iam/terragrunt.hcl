include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../..//stacks/iam"
}

inputs = {
  name_prefix = "${local.env.locals.project_name}-${local.env.locals.environment}"
}
