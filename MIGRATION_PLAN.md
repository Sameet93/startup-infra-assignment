# Migration Plan

## Objective

The goal over the next 6 to 12 months is to move from a manually deployed VM-based setup to a repeatable, observable, and scalable AWS platform that can:

- support increased demand
- absorb performance spikes without user-facing downtime
- provide clear operational visibility
- support predictable outbound IPs for partner allowlisting
- establish safe delivery through CI/CD and infrastructure as code

This plan assumes the application starts as a modular monolith and evolves by separating background processing from synchronous user traffic, rather than immediately splitting into many microservices.

## Target Environment Model

The platform should use four environments with clear purpose and promotion flow:

- `dev`
  - Used by engineers for day-to-day changes and fast iteration
  - Lower-cost sizing and relaxed scaling
  - Frequent deploys
- `testing`
  - Used for automated integration, smoke, and regression testing
  - Close enough to production behavior to catch environment-specific issues
  - Can be ephemeral for PR validation or persistent for shared QA
- `stage`
  - Pre-production environment used for release validation
  - Mirrors production topology more closely
  - Used for migration rehearsal, load checks, and deployment verification
- `prod`
  - Customer-facing environment
  - Strictest change controls, observability, rollback, and security posture

Recommended promotion path:

`dev -> testing -> stage -> prod`

## Platform Direction

### Runtime

- ECS on Fargate for the web service
- ECS on Fargate for background workers
- SQS between web and workers for burst absorption

### Infrastructure

- Terraform for all core AWS resources
- Reusable modules for networking, ECS, IAM, CloudWatch, RDS, and later SQS/secrets

### Delivery

- GitHub Actions for CI/CD
- Environment-aware deployment pipeline with approvals for `stage` and `prod`

### Data

- Amazon RDS for PostgreSQL as the system of record
- RDS Proxy or PgBouncer for connection management

### Observability

- CloudWatch for logs, metrics, dashboards, and alarms
- OpenTelemetry for traces and application metrics

## Migration Principles

- Avoid big-bang rewrites
- Keep the application running during migration
- Move the platform first, then optimize workload separation
- Treat observability as part of the migration, not a later add-on
- Promote changes through environments before production

## 0 To 3 Months

These are the highest-priority items because they reduce immediate operational risk and create a foundation for future scale.

### 1. Standardize Infrastructure With Terraform

- Create reusable Terraform modules for:
  - networking
  - ECS
  - IAM
  - CloudWatch
  - RDS
  - later SQS and secrets
- Create environment compositions for `dev`, `testing`, `stage`, and `prod`
- Introduce remote Terraform state and state locking

Why first:

- Without IaC, every other improvement stays fragile and hard to reproduce.

### 2. Introduce Containerized Deployment To ECS

- Containerize the app if needed
- Deploy the app behind an ALB on ECS Fargate
- Run at least two tasks in `stage` and `prod`
- Add health checks and deployment rollback behavior

Why first:

- This removes SSH-based manual deployment and gives safer scaling primitives quickly.

### 3. Build CI/CD

- PR pipeline:
  - install
  - lint/typecheck
  - unit tests
  - integration tests
  - image build
  - Terraform fmt/validate
- Main branch pipeline:
  - push image to ECR
  - deploy to `dev`
  - promote to `testing` and `stage`
  - production deployment with approval

Why first:

- It makes releases safer and gives a repeatable way to promote changes across environments.

### 4. Add Core Observability

- Centralized application logs in CloudWatch
- ECS, ALB, and RDS dashboards
- Alerts for:
  - 5xx rates
  - latency
  - task restarts
  - CPU and memory pressure
  - queue backlog later
  - database storage and connections

Why first:

- The assignment requires observability, and it is necessary to manage migration risk.

### 5. Secure Network Baseline

- Public subnets only for ALB and NAT
- ECS tasks and RDS in private subnets for `stage` and `prod`
- Fixed outbound IP via NAT Gateway with Elastic IP for partner allowlisting

Why first:

- Predictable egress IP is a stated requirement and should not be treated as optional.

## 3 To 6 Months

### 1. Separate Heavy Workloads From User Traffic

- Move expensive tasks off the request path
- Add SQS queue and dead-letter queue
- Add a separate ECS worker service
- Scale workers by queue depth, CPU, and memory

Outcome:

- Large partner or customer spikes no longer directly degrade the web tier.

### 2. Strengthen Environment Strategy

- `dev` stays fast and inexpensive
- `testing` runs automated smoke and integration checks after each deploy
- `stage` becomes the rehearsal environment for migrations and release validation
- `prod` adds stricter approvals and rollback controls

### 3. Improve Secrets And IAM

- Move application secrets to Secrets Manager or SSM Parameter Store
- Tighten IAM so tasks receive least-privilege access only
- Remove long-lived shared credentials where possible

### 4. Deployment Safety

- Add blue/green or progressive rollout for `stage` and `prod`
- Add pre-deploy and post-deploy smoke tests
- Add automated rollback on health check failure

## 6 To 12 Months

### 1. Mature Database Scale Strategy

- Introduce connection pooling consistently
- Batch high-volume writes
- Rework row-at-a-time inserts into bulk operations where possible
- Add read replicas if read pressure grows
- Partition the largest tables if write volume or retention growth requires it
- Evaluate Aurora PostgreSQL only if scaling or operational needs justify the move

### 2. Expand Observability

- Add OpenTelemetry tracing across web, worker, and database calls
- Add service-level indicators and alert thresholds
- Add business metrics for client job volume, processing time, and failure rates

### 3. Improve Resilience And Security

- Add WAF in front of the ALB
- Add tighter network segmentation
- Add backup restore testing and disaster recovery exercises
- Add production access controls and audit review

## Low-Downtime Migration Sequence

The recommended migration path minimizes downtime by introducing the new platform alongside the old one.

### Phase 1: Prepare Non-Production Environments

- Build `dev` and `testing` first
- Prove Terraform, ECS deployment, logging, and basic CI/CD
- Fix operational gaps before any production cutover

### Phase 2: Build Stage As A Production Mirror

- Add `stage` with production-like topology
- Validate:
  - app startup
  - environment configuration
  - DB connectivity
  - log ingestion
  - scaling
  - deployment rollback

### Phase 3: Production Platform In Parallel

- Stand up new `prod` ECS infrastructure beside the existing EC2-based deployment
- Keep the old environment serving traffic while the new one is verified
- Use a production clone or carefully controlled access to validate application behavior

### Phase 4: Controlled Data And App Cutover

- Use backward-compatible database migrations
- Ensure application code can run against both current and newly migrated schema during cutover
- Shift traffic gradually:
  - start with internal checks
  - then a small percentage of traffic if tooling supports it
  - then full cutover once health and metrics are stable

### Phase 5: Move Heavy Jobs Last

- After the web app is stable on ECS, move expensive tasks to SQS-backed workers
- This reduces risk because web cutover and workload isolation are not happening at the exact same time

### Phase 6: Decommission Legacy EC2 Deployment

- Only remove the legacy environment after:
  - error rates are stable
  - performance is acceptable
  - partner egress IP requirements are met
  - rollback confidence is high

## Database Scalability Approach

The database strategy should focus on eliminating avoidable pressure before jumping to exotic architectures.

### Short Term

- Keep PostgreSQL as the source of truth
- Move heavy writes off the request path
- Add indexes for the highest-value query paths
- Use RDS Performance Insights and metrics to identify bottlenecks
- Add connection pooling through RDS Proxy or PgBouncer

### Medium Term

- Convert large insert loops into batch writes or bulk load patterns
- Introduce read replicas if reporting or read traffic becomes significant
- Partition very large write-heavy tables by time or tenant if needed

### Longer Term

- Evaluate Aurora PostgreSQL if:
  - failover requirements become stricter
  - replica scaling needs increase
  - operational overhead of standard RDS becomes limiting

This is intentionally more conservative than immediately proposing sharding. Most startups benefit far more from async processing, batching, pooling, and schema/query improvements before considering sharding.

## Testing Strategy Across Environments

### Dev

- developer smoke checks
- rapid deploy verification
- infrastructure iteration

### Testing

- automated integration tests
- migration validation
- API and background job regression tests

### Stage

- production-like release rehearsal
- load and scaling checks
- partner integration validation using allowlisted egress

### Prod

- health checks
- deployment verification
- alarms and rollback readiness

## AI-Generated Code And Timeline Assistance

AI assistance can be useful in this assignment, especially because the expected timeline is 6 to 8 focused hours and the deliverables span architecture, IaC, documentation, and possibly CI/CD or observability.

Appropriate use of AI:

- drafting Terraform boilerplate
- generating repetitive module skeletons
- helping organize README and migration-plan structure
- proofreading and tightening wording
- suggesting checklists for rollout phases

Where AI should not replace engineering judgment:

- ECS vs Kubernetes trade-off reasoning
- migration sequencing and downtime strategy
- database scaling choices
- environment promotion model
- risk analysis

Practical timeline benefit:

- AI can reduce time spent on boilerplate and formatting
- that reclaimed time should be spent on:
  - validating assumptions
  - improving trade-off quality
  - checking Terraform structure
  - making the migration plan realistic

Recommended disclosure in the final README:

- list the tools used
- summarize which parts AI helped draft
- explain what was materially reviewed or changed by hand
- note how outputs were validated

## Risks And Mitigations

### Risk: ECS Migration Alone Does Not Solve Spike Problems

Mitigation:

- move heavy jobs to async workers instead of expecting the web service to absorb all bursts

### Risk: Database Becomes The New Bottleneck

Mitigation:

- add batching, pooling, read replicas where needed, and monitor write hotspots early

### Risk: Partner IP Allowlisting Breaks During Migration

Mitigation:

- introduce NAT-based fixed egress before production partner cutover
- test integrations in `stage`

### Risk: Environment Drift

Mitigation:

- use Terraform modules plus environment compositions
- promote through `dev`, `testing`, `stage`, and `prod`

### Risk: AI-Assisted Boilerplate Introduces Subtle Errors

Mitigation:

- manually review code and architecture text
- run Terraform validation
- keep rationale explainable without AI

## Summary

The migration should prioritize platform safety and workload isolation over premature architectural complexity. The best near-term path is:

- Terraform-managed environments
- ECS on Fargate for web and workers
- GitHub Actions for CI/CD
- CloudWatch and OTel-based observability
- PostgreSQL with pragmatic scaling improvements
- `dev`, `testing`, `stage`, and `prod` promotion flow

This approach is realistic for a first DevOps hire, addresses the assignment requirements directly, and creates a foundation that can scale with the company over the next year.
