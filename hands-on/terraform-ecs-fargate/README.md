# Terraform ECS Fargate Demo

## Overview

This hands-on demo now combines Terraform and Terragrunt in three layers:

- `_modules/`
  - reusable Terraform resource definitions
- `stacks/`
  - thin Terraform wrappers that use `data` blocks and call the reusable modules
- `platform/`
  - Terragrunt environment orchestration for `dev`, `testing`, `stage`, and `prod`

This structure is intended to achieve three goals at once:

- avoid repeating environment boilerplate
- allow each stack to be targeted independently
- keep reusable modules free of environment-specific lookup logic

## Layout

```text
terraform-ecs-fargate/
├── _modules/
│   ├── cloudwatch/
│   ├── ecs/
│   ├── iam/
│   ├── networking/
│   └── rds/
├── stacks/
│   ├── cloudwatch/
│   ├── ecs/
│   ├── iam/
│   ├── networking/
│   └── rds/
└── platform/
    ├── terragrunt.hcl
    ├── dev/
    │   ├── Makefile
    │   ├── env.hcl
    │   ├── networking/terragrunt.hcl
    │   ├── iam/terragrunt.hcl
    │   ├── cloudwatch/terragrunt.hcl
    │   ├── ecs/terragrunt.hcl
    │   └── rds/terragrunt.hcl
    ├── testing/
    │   ├── Makefile
    │   ├── env.hcl
    │   ├── networking/terragrunt.hcl
    │   ├── iam/terragrunt.hcl
    │   ├── cloudwatch/terragrunt.hcl
    │   ├── ecs/terragrunt.hcl
    │   └── rds/terragrunt.hcl
    ├── stage/
    │   ├── Makefile
    │   ├── env.hcl
    │   ├── networking/terragrunt.hcl
    │   ├── iam/terragrunt.hcl
    │   ├── cloudwatch/terragrunt.hcl
    │   ├── ecs/terragrunt.hcl
    │   └── rds/terragrunt.hcl
    └── prod/
        ├── Makefile
        ├── env.hcl
        ├── networking/terragrunt.hcl
        ├── iam/terragrunt.hcl
        ├── cloudwatch/terragrunt.hcl
        ├── ecs/terragrunt.hcl
        └── rds/terragrunt.hcl
```

## What This Demo Provisions

- VPC
- Public subnets
- Private subnets
- Internet Gateway, NAT gateway, and route tables
- Security groups for the ALB, ECS service, and database
- CloudWatch log group
- ECS cluster, task definition, ALB, service, and autoscaling
- Optional RDS scaffold

The sample application uses a public NGINX image so the hands-on portion stays small and easy to inspect.

The demo keeps the values realistic:

- valid Fargate CPU and memory combinations
- real CIDR ranges
- environment-specific sizing differences
- derived names for state resources and stack resources

It is still review-only, but it now reads like a real small-footprint Fargate setup instead of a placeholder sketch.

## Network Shape

The demo intentionally models a more production-aware network layout than the bare minimum:

- the ALB sits in public subnets
- ECS tasks run in private subnets
- the optional RDS instance also uses private subnets
- outbound internet access for private workloads flows through a NAT gateway

That keeps the hands-on slice aligned with the architecture write-up, where partner integrations and fixed egress paths matter.

## Why Use Both Terraform And Terragrunt

Terraform and Terragrunt are doing different jobs here.

### Terraform Responsibilities

Terraform is responsible for:

- defining AWS resources
- using AWS `data` sources only where provider-derived lookups make sense
- exposing outputs from each stack

### Terragrunt Responsibilities

Terragrunt is responsible for:

- multi-environment structure
- shared remote state configuration
- shared provider generation
- passing dependency outputs between stacks
- reducing repeated root configuration

That split is the cleanest way to keep the codebase maintainable as more environments are added.

## How Terragrunt Works Here

### 1. Shared Parent Config

[`platform/terragrunt.hcl`](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/terragrunt.hcl:1) is the shared parent config.

It defines:

- S3 remote state configuration
- DynamoDB locking
- generated AWS provider configuration
- shared environment locals loaded from `env.hcl`

This means those settings do not need to be repeated in every environment stack.

### 2. Environment Values

Each environment has its own `env.hcl`, for example:

- [platform/dev/env.hcl](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev/env.hcl:1)
- [platform/testing/env.hcl](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/testing/env.hcl:1)
- [platform/stage/env.hcl](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/stage/env.hcl:1)
- [platform/prod/env.hcl](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/prod/env.hcl:1)

These files hold environment-specific values such as:

- AWS region
- environment name
- project name
- network CIDR
- task sizing
- scaling settings
- optional database toggle

The remote-state bucket and lock-table names are derived centrally from `project_name` and `environment` in [`platform/terragrunt.hcl`](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/terragrunt.hcl:1).

### 3. Stack-Level Terragrunt Config

Each stack directory contains a `terragrunt.hcl` that:

- includes the shared root config
- points to a Terraform wrapper in `stacks/`
- passes inputs to that wrapper
- declares stack dependencies where needed

Examples:

- [platform/dev/networking/terragrunt.hcl](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev/networking/terragrunt.hcl:1)
- [platform/dev/ecs/terragrunt.hcl](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev/ecs/terragrunt.hcl:1)

### 4. Dependencies

Terragrunt `dependency` blocks provide outputs from one stack to another.

For example:

- `ecs` depends on:
  - `networking`
  - `iam`
  - `cloudwatch`
- `rds` depends on:
  - `networking`

That is how the ECS and RDS stacks get:

- VPC ID
- subnet IDs
- security group IDs
- log group name
- execution role ARN

without hand-writing repetitive `terraform_remote_state` blocks in every environment.

## How Terraform Works Here

### 1. Reusable Modules

The `_modules/` directory contains pure reusable infrastructure modules:

- [networking](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/_modules/networking:1)
- [iam](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/_modules/iam:1)
- [cloudwatch](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/_modules/cloudwatch:1)
- [ecs](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/_modules/ecs:1)
- [rds](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/_modules/rds:1)

These modules do not contain environment-specific discovery logic.

### 2. Thin Stack Wrappers

The `stacks/` directory contains thin Terraform wrappers:

- [stacks/networking](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/networking:1)
- [stacks/iam](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/iam:1)
- [stacks/cloudwatch](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/cloudwatch:1)
- [stacks/ecs](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/ecs:1)
- [stacks/rds](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/rds:1)

These wrappers exist so Terraform can do provider lookups where needed and keep the reusable modules focused on resource creation.

### 3. Data Blocks Live In Wrappers, Not Modules

This is the pattern you asked for.

For example:

- [stacks/networking/main.tf](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/networking/main.tf:1)
  - reads available AWS availability zones
  - selects the number of zones required for the requested public and private subnet counts
  - then calls the networking module
- [stacks/ecs/main.tf](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/ecs/main.tf:1)
  - accepts VPC, subnet, security group, IAM, and log outputs directly from Terragrunt dependencies
  - then calls the ECS module
- [stacks/rds/main.tf](/opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/stacks/rds/main.tf:1)
  - accepts subnet and database security-group outputs directly from the networking stack
  - then calls the RDS module

So the pattern is:

- Terragrunt passes outputs between stacks for resources this repo creates
- Terraform wrapper uses `data` blocks only for provider-derived values such as availability zones
- Terraform module creates resources using the resolved values

That is the combined Terraform + Terragrunt model you asked for.

## Independence And Connections

Each stack can be targeted independently from an environment root, for example:

- `platform/dev/networking`
- `platform/dev/iam`
- `platform/dev/cloudwatch`
- `platform/dev/ecs`
- `platform/dev/rds`

But “independent” here means independently addressable, not dependency-free.

For example:

- `networking` can be created on its own
- `iam` can be created on its own
- `cloudwatch` can be created on its own
- `ecs` requires networking, IAM, and CloudWatch outputs
- `rds` requires networking outputs

Those connections are now present through Terragrunt dependencies and direct stack outputs.

## How To Run

Prerequisites:

- Terraform installed
- Terragrunt installed
- AWS CLI configured
- an S3 bucket for Terraform state
- a DynamoDB table for state locking

Before running for real:

- the environment files now use realistic demo values, including valid Fargate sizes and derived naming conventions
- the S3 backend bucket and DynamoDB lock-table names are derived automatically from `project_name` and `environment`
- to actually apply this, you would still need to bootstrap those backend resources first
- for a real deployment, you would also move database credentials out of `env.hcl` and into Secrets Manager or SSM Parameter Store

### Review-Only Dry Run

This is the workflow I actually validated for the take-home submission.

It avoids creating infrastructure and bypasses the placeholder remote-state settings by using:

- `TG_USE_LOCAL_BACKEND=true`
- `TG_USE_MOCK_OUTPUTS=true`

Example for `dev`:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev
TG_USE_LOCAL_BACKEND=true TG_USE_MOCK_OUTPUTS=true terragrunt run-all init
TG_USE_LOCAL_BACKEND=true TG_USE_MOCK_OUTPUTS=true terragrunt run-all plan
```

The same pattern can be used for `testing`, `stage`, and `prod`.

### Deploy A Full Environment

For `dev`:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

For `stage`:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/stage
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

Each environment root also has a `Makefile` that runs stacks in dependency order. For example from `platform/dev`:

```bash
make init-all
make apply-all
```

### Deploy A Single Stack

For example, ECS in `dev`:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev/ecs
terragrunt init
terragrunt plan
terragrunt apply
```

Or from the environment root:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev
make apply-ecs
```

## How To Destroy

Destroy a full environment:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev
terragrunt run-all destroy
```

Or from the environment root with ordered teardown:

```bash
cd /opt/sameet/code/startup-infra-assignment/hands-on/terraform-ecs-fargate/platform/dev
make destroy-all
```

## How To Inspect

- ALB DNS name in Terraform outputs from the ECS stack
- ECS cluster and service in the AWS console
- CloudWatch log group
- S3 state keys separated by environment and stack
- dependency outputs flowing into ECS and RDS through Terragrunt
- availability zone lookup in the networking wrapper and direct stack outputs in the ECS and RDS wrappers

## Assumptions

- The same core topology is acceptable across environments for this demo.
- The configuration should look like a real small-scale Fargate setup even though this repository is not being applied.
- RDS is optional and disabled by default in the environment configs.
- A single NAT gateway is acceptable for the demo even though a production build would likely use a higher-availability egress pattern.
- HTTP-only ALB ingress is acceptable in the hands-on slice; TLS would be added in the full production setup with ACM and Route 53.

## Shortcuts Taken

- The backend bucket and lock-table names are derived, but the bootstrap resources themselves are not created in this demo.
- The environment files still keep the demo database password inline because the RDS stack is disabled and Secrets Manager is outside the current scope.
- The networking layout uses a single NAT gateway for clarity and lower demo complexity.
- The same stack pattern is reused across environments with only light sizing differences.
- No CI/CD pipeline is included in this specific hands-on slice.
- No SQS worker service is included.
- No OTel collector is included.

## What I Would Do Next

- tune `testing`, `stage`, and `prod` sizing more realistically
- add VPC endpoints and tighter egress controls around the NAT path
- make NAT highly available across multiple AZs where justified by cost and uptime targets
- add SQS and a worker service
- add Secrets Manager integration
- add GitHub Actions jobs that run Terragrunt `hclfmt`, `validate`, `plan`, and controlled apply

## AI Assistance Disclosure

Tools used:

- OpenAI Codex for scaffolding, refactoring, and documentation support

Prompts and modifications:

- I made the architectural direction and trade-off decisions myself, including the choice of ECS on Fargate, Terraform plus Terragrunt, GitHub Actions, and the multi-environment promotion model.
- I used AI primarily to accelerate implementation work, including refactoring the earlier Terraform-only layout into a Terragrunt-based multi-environment structure and drafting supporting documentation.
- I manually reviewed the resulting architecture explanation to ensure the claims about stack deployment, environment deployment, dependency handling, and module boundaries were accurate.

Verification:

- I manually reviewed the Terragrunt layout and dependency structure.
- I formatted the Terraform files.
- I ran Terragrunt `init` and `plan` across `dev`, `testing`, `stage`, and `prod` in dry-run mode using a local backend and mock dependency outputs.
- I did not run a live deployment or `apply` because this repo is intentionally review-only and uses non-production placeholder values.
