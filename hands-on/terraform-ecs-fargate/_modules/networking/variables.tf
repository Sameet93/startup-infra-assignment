variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used when creating public and private subnets."
  type        = list(string)
}

variable "public_subnet_count" {
  description = "Number of public subnets to create."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create."
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Application port allowed from the ALB to ECS."
  type        = number
}
