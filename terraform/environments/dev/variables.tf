variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "docker_image_uri" {
  description = "URI of the Docker image for the Lambda function"
  type        = string
  default     = "public.ecr.aws/lambda/python:3.11" # default placeholder
}
