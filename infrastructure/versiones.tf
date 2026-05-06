terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Descomenta esto si usas backend remoto en S3
  # backend "s3" {
  #   bucket         = "tfstate-image-processor"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-2"
  #   encrypt        = true
  #   dynamodb_table = "tfstate-lock"
  # }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "image-processor"
      ManagedBy   = "Terraform"
      CreatedAt   = timestamp()
    }
  }
}
