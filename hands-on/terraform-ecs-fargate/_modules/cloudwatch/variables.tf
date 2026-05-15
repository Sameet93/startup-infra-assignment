variable "log_group_name" {
  description = "CloudWatch log group name."
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch log retention."
  type        = number
  default     = 14
}
