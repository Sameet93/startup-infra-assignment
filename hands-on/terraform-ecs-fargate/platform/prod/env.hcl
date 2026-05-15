locals {
  # Realistic demo values. This repo is review-only, but the configuration
  # uses valid naming, CIDRs, and small Fargate sizing.
  environment  = "prod"
  aws_region   = "us-west-2"
  project_name = "sameet-startup-platform"

  vpc_cidr             = "10.45.0.0/16"
  public_subnet_count  = 2
  private_subnet_count = 2
  app_port             = 80
  log_retention_days   = 30
  container_image      = "public.ecr.aws/docker/library/nginx:stable-alpine"
  container_cpu        = 512
  container_memory     = 1024
  desired_count        = 2
  min_capacity         = 2
  max_capacity         = 6
  health_check_path    = "/"
  enable_rds           = false
  db_name              = "app"
  db_username          = "app_admin"
  db_password          = "DemoOnlyPassword123!"
}
