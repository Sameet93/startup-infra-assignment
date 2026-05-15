# Startup Infra Assignment

This folder contains the deliverables for the take-home infrastructure assignment.

## Contents

- [ARCHITECTURE.md](./ARCHITECTURE.md): target-state architecture proposal and system diagram
- [MIGRATION_PLAN.md](./MIGRATION_PLAN.md): phased migration plan, environment strategy, and database scalability approach
- [hands-on/terraform-ecs-fargate/README.md](./hands-on/terraform-ecs-fargate/README.md): hands-on demo documentation
- [AI_ASSISTANCE_BRIEF.md](./AI_ASSISTANCE_BRIEF.md): concise AI assistance disclosure
- `hands-on/terraform-ecs-fargate/`: Terraform demo for a basic ECS Fargate service with autoscaling

## Chosen Hands-On Area

The hands-on demo uses Terraform and Terragrunt to model a small ECS Fargate platform with:

- a VPC with public and private subnets
- a NAT gateway for outbound access from private workloads
- an Application Load Balancer
- an ECS cluster and service
- CloudWatch logs
- CPU and memory-based autoscaling
- environment orchestration for `dev`, `testing`, `stage`, and `prod`

This was chosen because it aligns directly with the proposed production architecture and demonstrates the most important platform patterns for the scenario.

## Notes

- The demo is intentionally smaller than the full architecture proposal.
- It focuses on the core runtime, networking, and scaling pattern rather than the full production estate.
- The production design in `ARCHITECTURE.md` still assumes additional pieces such as RDS, SQS workers, secrets management, and observability improvements.
- The migration sequencing, environment promotion model, and database scale strategy are documented in `MIGRATION_PLAN.md`.

## AI Assistance Disclosure

Tools used:

- OpenAI Codex for implementation scaffolding, refactoring support, and documentation drafting

Prompts and modifications:

- I used AI to accelerate boilerplate and repo organization work around the Terraform and Terragrunt demo.
- I reviewed and adjusted the output myself, especially around architecture trade-offs, stack boundaries, networking, and documentation.
- The final design choices and prioritization reflect my own reasoning.

Verification:

- I manually reviewed the generated code and documentation.
- I formatted the Terraform code and checked the structure for consistency.
- I ran Terragrunt `init` and `plan` in dry-run mode across all environments.
- I did not run a live deployment or `apply` because the repo uses review-only placeholder values.
