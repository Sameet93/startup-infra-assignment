locals {
  env_config = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment       = local.env_config.locals.environment
  aws_region        = local.env_config.locals.aws_region
  project_name      = local.env_config.locals.project_name
  project_slug      = replace(local.project_name, "_", "-")
  state_bucket      = "${local.project_slug}-${local.environment}-terraform-state"
  lock_table        = "${local.project_slug}-${local.environment}-terraform-locks"
  use_local_backend = get_env("TG_USE_LOCAL_BACKEND", "false") == "true"
}

remote_state {
  backend = local.use_local_backend ? "local" : "s3"

  config = local.use_local_backend ? {
    path = "${path_relative_to_include()}/terraform.tfstate"
  } : {
    bucket         = local.state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = local.lock_table
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = {
      Project     = "${local.project_name}"
      Environment = "${local.environment}"
      ManagedBy   = "Terragrunt"
    }
  }
}
EOF
}
