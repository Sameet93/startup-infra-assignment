# AI Assistance Disclosure (Concise)

## Tools Used

- OpenAI Codex for implementation scaffolding, refactoring support, and documentation drafting

## Prompts And Modifications

- I made the architectural direction and final trade-off decisions myself.
- I used AI primarily to accelerate implementation scaffolding, repo organization, and documentation around the Terraform and Terragrunt demo.
- I reviewed and adjusted the output myself, especially around stack boundaries, networking, and final wording.

## Verification

- I manually reviewed the generated code and documentation.
- I formatted the Terraform code and checked the structure for consistency.
- I ran Terragrunt `init` and `plan` in dry-run mode across all environments.
- I did not run a live deployment or `apply` because the repo uses review-only placeholder values.
