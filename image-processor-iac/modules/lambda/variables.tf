variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "upload_lambda_role_arn" {
  type = string
}

variable "crop_lambda_role_arn" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "sqs_queue_url" {
  type = string
}

variable "lambda_upload_sg_id" {
  type = string
}

variable "lambda_crop_sg_id" {
  type = string
}

variable "private_subnet_a_id" {
  type = string
}

variable "private_subnet_b_id" {
  type = string
}
variable "sqs_queue_arn" {
  type = string
}
