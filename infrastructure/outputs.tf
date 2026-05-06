output "api_gateway_url" {
  description = "API Gateway HTTP API endpoint URL"
  value       = module.api_gateway.api_endpoint
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for images"
  value       = module.s3.bucket_name
}

output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = module.sqs.queue_url
}

output "upload_lambda_arn" {
  description = "ARN of the upload Lambda function"
  value       = module.lambda.upload_lambda_arn
}

output "crop_lambda_arn" {
  description = "ARN of the crop Lambda function"
  value       = module.lambda.crop_lambda_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "cloudwatch_alarm_arn" {
  description = "CloudWatch alarm ARN for DLQ"
  value       = module.observability.dlq_alarm_arn
}
