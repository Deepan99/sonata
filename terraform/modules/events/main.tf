variable "environment" {
  type = string
}

variable "documents_bucket_id" {
  type = string
}

variable "lambda_function_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

# Example EventBridge rule for S3 bucket notifications
# S3 must be configured to send events to EventBridge for this to work natively
resource "aws_cloudwatch_event_rule" "s3_upload" {
  name        = "s3-doc-upload-${var.environment}"
  description = "Trigger lambda on S3 upload"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [var.documents_bucket_id]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.s3_upload.name
  target_id = "ProcessDocument"
  arn       = var.lambda_function_arn
}

resource "aws_lambda_permission" "eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_upload.arn
}
