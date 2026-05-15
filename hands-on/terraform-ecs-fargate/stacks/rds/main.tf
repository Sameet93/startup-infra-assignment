module "rds" {
  source = "../../_modules/rds"

  create                = var.create
  name_prefix           = var.name_prefix
  subnet_ids            = var.subnet_ids
  security_group_ids    = var.security_group_ids
  db_name               = var.db_name
  username              = var.username
  password              = var.password
  instance_class        = var.instance_class
  engine_version        = var.engine_version
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  publicly_accessible   = var.publicly_accessible
}
