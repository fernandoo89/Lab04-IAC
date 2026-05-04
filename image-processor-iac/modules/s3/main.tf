# Generar suffix aleatorio para unicidad global del bucket
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  lower   = true
}

# Bucket S3
resource "aws_s3_bucket" "images" {
  bucket = "${var.project_name}-${var.environment}-images-${random_string.bucket_suffix.result}"
}

# Versionado habilitado
resource "aws_s3_bucket_versioning" "images" {
  bucket = aws_s3_bucket.images.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado AES-256 (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquear acceso público
resource "aws_s3_bucket_public_access_block" "images" {
  bucket = aws_s3_bucket.images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Ciclo de vida: expirar uploads después de 30 días, processed después de 90 días
resource "aws_s3_bucket_lifecycle_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    id     = "expire-uploads"
    status = "Enabled"
    filter {
      prefix = "uploads/"
    }
    expiration {
      days = 30
    }
  }

  rule {
    id     = "expire-processed"
    status = "Enabled"
    filter {
      prefix = "processed/"
    }
    expiration {
      days = 90
    }
  }
}

# Política para permitir a S3 enviar notificaciones a SQS
resource "aws_sqs_queue_policy" "allow_s3_to_sqs" {
  queue_url = var.sqs_queue_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = var.sqs_queue_arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}

# Notificación a SQS cuando se crea un objeto en uploads/
resource "aws_s3_bucket_notification" "images_to_sqs" {
  bucket      = aws_s3_bucket.images.id
  depends_on  = [aws_sqs_queue_policy.allow_s3_to_sqs]

  queue {
    queue_arn     = var.sqs_queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "uploads/"
  }
}
