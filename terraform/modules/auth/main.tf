variable "environment" {
  type = string
}

resource "aws_cognito_user_pool" "pool" {
  name = "doc-processing-users-${var.environment}"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "doc-processing-client-${var.environment}"
  user_pool_id = aws_cognito_user_pool.pool.id
  
  generate_secret = false
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.pool.arn
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}
