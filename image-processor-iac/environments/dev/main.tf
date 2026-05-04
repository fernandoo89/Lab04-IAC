terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Descomenta para usar backend remoto
  # backend "s3" {
  #   bucket         = "tfstate-image-processor-dev"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "tfstate-lock-dev"
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
    }
  }
}

# Obtener el account ID actual
data "aws_caller_identity" "current" {}

# ============================================================================
# MÓDULO: NETWORKING (VPC, Subnets, NATs, VPC Endpoints)
# ============================================================================
module "networking" {
  source = "../../modules/networking"

  project_name   = var.project_name
  environment    = var.environment
  vpc_cidr       = var.vpc_cidr
  enable_nat_ha  = var.enable_nat_ha
  aws_region     = var.aws_region
}

# ============================================================================
# MÓDULO: IAM (Roles y Policies)
# ============================================================================
module "iam" {
  source = "../../modules/iam"

  project_name    = var.project_name
  environment     = var.environment
  s3_bucket_arn   = module.s3.bucket_arn
  sqs_queue_arn   = module.sqs.queue_arn
  sqs_dlq_arn     = module.sqs.dlq_arn
}

# ============================================================================
# MÓDULO: S3 (Bucket, Versioning, Lifecycle)
# ============================================================================
module "s3" {
  source = "../../modules/s3"

  project_name    = var.project_name
  environment     = var.environment
  aws_account_id  = data.aws_caller_identity.current.account_id
  sqs_queue_arn   = module.sqs.queue_arn
}

# ============================================================================
# MÓDULO: SQS (Queue, DLQ, Alarma)
# ============================================================================
module "sqs" {
  source = "../../modules/sqs"

  project_name    = var.project_name
  environment     = var.environment
  aws_account_id  = data.aws_caller_identity.current.account_id
}

# ============================================================================
# MÓDULO: LAMBDA (upload-lambda y crop-lambda)
# ============================================================================
module "lambda" {
  source = "../../modules/lambda"

  project_name         = var.project_name
  environment          = var.environment
  upload_lambda_role_arn = module.iam.upload_lambda_role_arn
  crop_lambda_role_arn   = module.iam.crop_lambda_role_arn
  s3_bucket_name       = module.s3.bucket_name
  sqs_queue_url        = module.sqs.queue_url
  sqs_queue_arn        = module.sqs.queue_arn  
  lambda_upload_sg_id  = module.networking.lambda_upload_sg_id
  lambda_crop_sg_id    = module.networking.lambda_crop_sg_id
  private_subnet_a_id  = module.networking.private_subnet_a_id
  private_subnet_b_id  = module.networking.private_subnet_b_id
}

# ============================================================================
# MÓDULO: API GATEWAY (HTTP API v2)
# ============================================================================
module "api_gateway" {
  source = "../../modules/api_gateway"

  project_name       = var.project_name
  environment        = var.environment
  upload_lambda_arn  = module.lambda.upload_lambda_arn
  upload_lambda_name = module.lambda.upload_lambda_name
  aws_region         = var.aws_region
  aws_account_id     = data.aws_caller_identity.current.account_id
}

# ============================================================================
# MÓDULO: OBSERVABILITY (CloudWatch Dashboards, Logs)
# ============================================================================
module "observability" {
  source = "../../modules/observability"

  project_name    = var.project_name
  environment     = var.environment
  dlq_alarm_arn   = module.sqs.sns_topic_arn
  sns_topic_arn   = module.sqs.sns_topic_arn
}
