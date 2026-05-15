variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
}

variable "app_port" {
  description = "App port allowed from ALB to ECS."
  type        = number
}
