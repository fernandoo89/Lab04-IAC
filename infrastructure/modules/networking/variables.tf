variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "enable_nat_ha" {
  type        = bool
  description = "Enable NAT Gateway High Availability (2 NATs). Set to false for dev/qa to save costs"
  default     = false
}

variable "aws_region" {
  type = string
}
