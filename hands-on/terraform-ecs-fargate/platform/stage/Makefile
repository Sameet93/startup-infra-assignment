STACKS := networking iam cloudwatch ecs rds

.PHONY: init-all plan-all apply-all destroy-all \
	init-networking plan-networking apply-networking destroy-networking \
	init-iam plan-iam apply-iam destroy-iam \
	init-cloudwatch plan-cloudwatch apply-cloudwatch destroy-cloudwatch \
	init-ecs plan-ecs apply-ecs destroy-ecs \
	init-rds plan-rds apply-rds destroy-rds

init-all: init-networking init-iam init-cloudwatch init-ecs init-rds

plan-all: init-all
	terragrunt run-all plan

apply-all: init-all apply-networking apply-iam apply-cloudwatch apply-ecs apply-rds

destroy-all: destroy-rds destroy-ecs destroy-cloudwatch destroy-iam destroy-networking

init-networking:
	cd networking && terragrunt init

plan-networking:
	cd networking && terragrunt plan

apply-networking:
	cd networking && terragrunt apply

destroy-networking:
	cd networking && terragrunt destroy

init-iam:
	cd iam && terragrunt init

plan-iam:
	cd iam && terragrunt plan

apply-iam:
	cd iam && terragrunt apply

destroy-iam:
	cd iam && terragrunt destroy

init-cloudwatch:
	cd cloudwatch && terragrunt init

plan-cloudwatch:
	cd cloudwatch && terragrunt plan

apply-cloudwatch:
	cd cloudwatch && terragrunt apply

destroy-cloudwatch:
	cd cloudwatch && terragrunt destroy

init-ecs:
	cd ecs && terragrunt init

plan-ecs:
	cd ecs && terragrunt plan

apply-ecs:
	cd ecs && terragrunt apply

destroy-ecs:
	cd ecs && terragrunt destroy

init-rds:
	cd rds && terragrunt init

plan-rds:
	cd rds && terragrunt plan

apply-rds:
	cd rds && terragrunt apply

destroy-rds:
	cd rds && terragrunt destroy
