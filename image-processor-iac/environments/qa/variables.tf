variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile"
  default     = "fbupao"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "qa"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "image-processor"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "enable_nat_ha" {
  type        = bool
  description = "Enable NAT Gateway HA (2 NATs)"
  default     = false  # QA tampoco necesita HA para ahorrar costos
}
