output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = module.api_gateway.api_endpoint
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = module.sqs.queue_url
}

output "upload_lambda_arn" {
  description = "Upload Lambda ARN"
  value       = module.lambda.upload_lambda_arn
}

output "crop_lambda_arn" {
  description = "Crop Lambda ARN"
  value       = module.lambda.crop_lambda_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}
