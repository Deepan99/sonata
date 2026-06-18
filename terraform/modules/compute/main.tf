variable "environment" {
  type = string
}

variable "docker_image_uri" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "documents_bucket_arn" {
  type = string
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "lambda_s3_access_${var.environment}"
  role = split("/", var.lambda_role_arn)[1]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${var.documents_bucket_arn}/*"
      }
    ]
  })
}

resource "aws_lambda_function" "processor" {
  function_name = "doc-processor-${var.environment}"
  role          = var.lambda_role_arn
  package_type  = "Image"
  image_uri     = var.docker_image_uri

  timeout = 30
  memory_size = 512

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

output "lambda_function_arn" {
  value = aws_lambda_function.processor.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.processor.invoke_arn
}
