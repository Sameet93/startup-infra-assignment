variable "create" {
  description = "Whether to create the RDS resources."
  type        = bool
}

variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs resolved from the networking stack state."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to the database."
  type        = list(string)
}

variable "db_name" {
  description = "Database name."
  type        = string
}

variable "username" {
  description = "Database username."
  type        = string
}

variable "password" {
  description = "Database password."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "16"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max autoscaled storage in GiB."
  type        = number
  default     = 100
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible."
  type        = bool
}
