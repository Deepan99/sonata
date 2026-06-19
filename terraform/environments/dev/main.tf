terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "devops-project-tf-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "devops-project-tf-locks-dev"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "DocumentProcessingService"
    }
  }
}

# --- Modules ---

module "network" {
  source      = "../../modules/network"
  environment = var.environment
}

module "storage" {
  source      = "../../modules/storage"
  environment = var.environment
  kms_key_arn = module.network.kms_key_arn
}

module "auth" {
  source      = "../../modules/auth"
  environment = var.environment
}

module "compute" {
  source               = "../../modules/compute"
  environment          = var.environment
  docker_image_uri     = var.docker_image_uri
  lambda_role_arn      = module.network.lambda_role_arn
  documents_bucket_arn = module.storage.documents_bucket_arn
}

module "api" {
  source                = "../../modules/api"
  environment           = var.environment
  lambda_invoke_arn     = module.compute.lambda_invoke_arn
  lambda_function_name  = module.compute.lambda_function_name
  cognito_user_pool_arn = module.auth.cognito_user_pool_arn
}

module "events" {
  source               = "../../modules/events"
  environment          = var.environment
  documents_bucket_id  = module.storage.documents_bucket_id
  lambda_function_arn  = module.compute.lambda_function_arn
  lambda_function_name = module.compute.lambda_function_name
}

output "api_gateway_url" {
  value = module.api.api_gateway_url
}

output "cognito_user_pool_id" {
  value = module.auth.cognito_user_pool_id
}

output "cognito_client_id" {
  value = module.auth.cognito_client_id
}
