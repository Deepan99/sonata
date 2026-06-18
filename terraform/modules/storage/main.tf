variable "environment" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

resource "aws_s3_bucket" "documents" {
  bucket = "doc-processing-storage-${var.environment}-${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_server_side_encryption_configuration" "documents_enc" {
  bucket = aws_s3_bucket.documents.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.documents.id
  eventbridge = true
}

output "documents_bucket_arn" {
  value = aws_s3_bucket.documents.arn
}

output "documents_bucket_id" {
  value = aws_s3_bucket.documents.id
}
