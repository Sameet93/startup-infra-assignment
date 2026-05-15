resource "aws_db_subnet_group" "main" {
  count      = var.create ? 1 : 0
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "postgres" {
  count = var.create ? 1 : 0

  identifier             = "${var.name_prefix}-postgres"
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = "gp3"
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.main[0].name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = true
  apply_immediately      = true
  storage_encrypted      = true
}
