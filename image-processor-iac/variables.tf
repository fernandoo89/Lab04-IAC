variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use"
  default     = "fbupao"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, qa, prod)"
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa, or prod."
  }
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "image-processor"
}

variable "enable_nat_ha" {
  type        = bool
  description = "Enable NAT Gateway High Availability (2 NATs) - set to false for dev/qa to save costs"
  default     = false
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}
