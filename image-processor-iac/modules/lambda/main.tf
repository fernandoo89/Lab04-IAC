# ============================================================================
# LAMBDA LAYER para dependencias (opcional, pero útil)
# ============================================================================

# ============================================================================
# UPLOAD LAMBDA FUNCTION
# ============================================================================

# Crear archivo ZIP simple para upload-lambda
data "archive_file" "upload_lambda_zip" {
  type        = "zip"
  output_path = "/tmp/upload-lambda.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Upload handler' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "upload" {
  filename         = data.archive_file.upload_lambda_zip.output_path
  function_name   = "${var.project_name}-${var.environment}-upload-lambda"
  role             = var.upload_lambda_role_arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.upload_lambda_zip.output_base64sha256
  timeout          = 30
  memory_size      = 256

  vpc_config {
    subnet_ids         = [var.private_subnet_a_id, var.private_subnet_b_id]
    security_group_ids = [var.lambda_upload_sg_id]
  }

  environment {
    variables = {
      S3_BUCKET      = var.s3_bucket_name
      UPLOAD_PREFIX  = "uploads/"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-upload-lambda"
  }
}

# CloudWatch Log Group para upload-lambda
resource "aws_cloudwatch_log_group" "upload_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.upload.function_name}"
  retention_in_days = 14
}

# ============================================================================
# CROP LAMBDA FUNCTION
# ============================================================================

# Crear archivo ZIP simple para crop-lambda
data "archive_file" "crop_lambda_zip" {
  type        = "zip"
  output_path = "/tmp/crop-lambda.zip"
  
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Crop handler' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "crop" {
  filename         = data.archive_file.crop_lambda_zip.output_path
  function_name   = "${var.project_name}-${var.environment}-crop-lambda"
  role             = var.crop_lambda_role_arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.crop_lambda_zip.output_base64sha256
  timeout          = 60
  memory_size      = 512

  vpc_config {
    subnet_ids         = [var.private_subnet_a_id, var.private_subnet_b_id]
    security_group_ids = [var.lambda_crop_sg_id]
  }

  environment {
    variables = {
      S3_BUCKET       = var.s3_bucket_name
      PROCESSED_PREFIX = "processed/"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-crop-lambda"
  }
}

# CloudWatch Log Group para crop-lambda
resource "aws_cloudwatch_log_group" "crop_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.crop.function_name}"
  retention_in_days = 14
}

# ============================================================================
# SQS EVENT SOURCE MAPPING para crop-lambda
# ============================================================================
resource "aws_lambda_event_source_mapping" "sqs_to_crop" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.crop.arn
  batch_size       = 5
  
  # Reportar solo los fallos en el lote, no todo el lote
  function_response_types = ["ReportBatchItemFailures"]
}
