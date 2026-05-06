# Este módulo es un placeholder
# Los CloudWatch Logs y alarmas ya están creados en otros módulos
# (Lambda, API Gateway, SQS)
# Aquí se pueden agregar más métricas y dashboards en el futuro

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", { stat = "Sum" }],
            [".", "Errors", { stat = "Sum" }],
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible"]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Application Metrics"
        }
      }
    ]
  })
}
