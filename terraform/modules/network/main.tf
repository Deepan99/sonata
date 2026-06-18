variable "environment" {
  type = string
}

resource "aws_kms_key" "main" {
  description             = "KMS key for Document Processing Service ${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_iam_role" "lambda_exec" {
  name = "doc-processing-lambda-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "kms_key_arn" {
  value = aws_kms_key.main.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec.arn
}

output "lambda_role_name" {
  value = aws_iam_role.lambda_exec.name
}
