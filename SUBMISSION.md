# Submission

Please find my take-home assignment submission here:

- GitHub repository: [https://github.com/Sameet93/startup-infra-assignment](https://github.com/Sameet93/startup-infra-assignment)

Repository contents:

- `ARCHITECTURE.md`
  - target-state architecture proposal
  - Mermaid system diagram
  - ECS vs Kubernetes trade-off reasoning
  - CI/CD, observability, and operational targets
- `MIGRATION_PLAN.md`
  - phased migration plan
  - 0 to 3 month priorities and later roadmap
  - low-downtime migration sequence
  - environment strategy for `dev`, `testing`, `stage`, and `prod`
  - database scalability approach
- `hands-on/terraform-ecs-fargate/`
  - Terraform and Terragrunt hands-on demo
  - run, inspect, and destroy instructions
  - assumptions, shortcuts, and next steps
- `README.md`
  - repository guide
  - validation summary
  - AI assistance disclosure

Notes:

- The hands-on demo focuses on infrastructure-as-code and models a small ECS Fargate platform with autoscaling.
- The broader production architecture, migration strategy, observability plan, and database-scaling approach are documented in the design files.
- The implementation was validated with Terragrunt `init` and `plan` in dry-run mode across all environments. No live `apply` was performed.
