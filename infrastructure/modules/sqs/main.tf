# Dead-Letter Queue (DLQ)
resource "aws_sqs_queue" "dlq" {
  name                       = "${var.project_name}-${var.environment}-image-dlq"
  message_retention_seconds  = 1209600  # 14 días
  visibility_timeout_seconds = 360       # 6 minutos
}

# Main Queue
resource "aws_sqs_queue" "main" {
  name                       = "${var.project_name}-${var.environment}-image-queue"
  visibility_timeout_seconds = 360  # 6 minutos (6x Lambda timeout de 60s)
  message_retention_seconds  = 86400  # 1 día
  receive_wait_time_seconds  = 20     # Long polling: 20 segundos

  # Configurar DLQ
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}

# SNS Topic para alarmas
resource "aws_sns_topic" "dlq_alarms" {
  name = "${var.project_name}-${var.environment}-dlq-alarms"
}

# CloudWatch Alarm para mensajes en DLQ
resource "aws_cloudwatch_metric_alarm" "dlq_messages" {
  alarm_name          = "${var.project_name}-${var.environment}-dlq-messages-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alert when messages appear in DLQ"
  alarm_actions       = [aws_sns_topic.dlq_alarms.arn]

  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }
}
