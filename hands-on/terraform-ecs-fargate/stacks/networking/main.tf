data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  required_az_count = max(var.public_subnet_count, var.private_subnet_count)
}

module "networking" {
  source = "../../_modules/networking"

  availability_zones   = slice(data.aws_availability_zones.available.names, 0, local.required_az_count)
  name_prefix          = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  app_port             = var.app_port
}
