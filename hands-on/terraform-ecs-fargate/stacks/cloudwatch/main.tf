module "cloudwatch" {
  source = "../../_modules/cloudwatch"

  log_group_name    = var.log_group_name
  retention_in_days = var.retention_in_days
}
