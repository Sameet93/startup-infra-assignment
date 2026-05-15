# Startup Infra Assignment

This repository contains my take-home submission for a DevOps assignment based on re-architecting a small AWS-hosted application over the next 6 to 12 months.

The submission includes:

- a target-state architecture proposal
- a phased migration plan with low-downtime rollout
- a hands-on Terraform and Terragrunt demo for a small ECS Fargate platform
- an AI assistance disclosure

## Repository Guide

- [ARCHITECTURE.md](./ARCHITECTURE.md)
  - target-state platform design
  - Mermaid system diagram
  - ECS vs Kubernetes reasoning
  - CI/CD, observability, and operational targets
- [MIGRATION_PLAN.md](./MIGRATION_PLAN.md)
  - 0 to 3 month priorities
  - 3 to 6 month and 6 to 12 month roadmap
  - environment strategy for `dev`, `testing`, `stage`, and `prod`
  - low-downtime migration sequence
  - database scalability approach
  - risks and mitigations
- [hands-on/terraform-ecs-fargate/README.md](./hands-on/terraform-ecs-fargate/README.md)
  - hands-on demo overview
  - run, inspect, and destroy instructions
  - assumptions, shortcuts, and next steps
- [AI_ASSISTANCE.md](./AI_ASSISTANCE.md)
  - standalone AI disclosure

## Recommended Review Order

1. Read [ARCHITECTURE.md](./ARCHITECTURE.md) for the overall platform direction.
2. Read [MIGRATION_PLAN.md](./MIGRATION_PLAN.md) for rollout sequencing, priorities, and database strategy.
3. Review [hands-on/terraform-ecs-fargate/README.md](./hands-on/terraform-ecs-fargate/README.md) and the Terraform / Terragrunt code for the implementation sample.

## Proposed Direction

- Runtime: `AWS ECS on Fargate`
- Infrastructure as code: `Terraform`, with `Terragrunt` for multi-environment composition
- CI/CD: `GitHub Actions`
- Database: `Amazon RDS for PostgreSQL`
- Spike handling: `Amazon SQS` with separate worker services for expensive tasks
- Fixed outbound IP: private subnets with `NAT Gateway` and Elastic IP
- Observability: `CloudWatch` plus `OpenTelemetry`

The central design choice is to keep the application as a modular monolith initially, but separate expensive background work from user-facing traffic. That addresses the stated memory and database pressure problems without introducing Kubernetes complexity too early.

## Hands-On Scope

For the implementation portion, I chose the Terraform option and built a small reviewable ECS Fargate platform that includes:

- a VPC with public and private subnets
- a NAT gateway for fixed outbound egress
- an Application Load Balancer
- an ECS cluster and service
- CloudWatch logging
- CPU and memory-based autoscaling
- environment structure for `dev`, `testing`, `stage`, and `prod`

The hands-on demo is intentionally narrower than the full design proposal. The architecture and migration documents describe additional production components such as SQS workers, fuller observability, secrets management, and a more complete database scale plan.

## Validation Summary

- I ran `terraform fmt -recursive` on the hands-on demo.
- I ran Terragrunt `init` and `plan` across `dev`, `testing`, `stage`, and `prod` in dry-run mode.
- I did not run `apply`, because this repo is intentionally review-only and uses placeholder values for environments and remote state.

## Notes

- The hands-on demo is structured to be clean and reviewable rather than production-ready.
- The repository uses realistic infrastructure shapes and sizing patterns, but the environment values are intentionally non-production.
- The Terraform and Terragrunt layout is designed to show reusable modules, stack wrappers, dependency wiring, and per-environment orchestration.

## AI Assistance Disclosure

Tools used:

- OpenAI Codex for implementation scaffolding, refactoring support, and documentation drafting

Prompts and modifications:

- I made the architectural direction and final trade-off decisions myself, including ECS on Fargate instead of Kubernetes, Terraform plus Terragrunt for IaC, GitHub Actions for CI/CD, and queue-based workload isolation for spike handling.
- I used AI primarily to accelerate implementation scaffolding, repository refactoring, and documentation drafting around the Terraform and Terragrunt demo.
- I reviewed and adjusted the output myself, especially around stack boundaries, networking, and final submission wording.

Verification:

- I manually reviewed the generated code and documentation.
- I formatted the Terraform code and checked the structure for consistency.
- I ran Terragrunt `init` and `plan` in dry-run mode across all environments.
- I did not run a live deployment or `apply` because the repo uses review-only placeholder values.
