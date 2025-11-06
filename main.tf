provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-public-insecure-bucket"
  acl    = "public-read"       # ❌ Public bucket — Checkov flags this
}

resource "aws_s3_bucket_public_access_block" "insecure_bucket_public_access" {
  bucket                  = aws_s3_bucket.insecure_bucket.id
  block_public_acls       = false  # ❌ Allows public ACLs
  block_public_policy     = false  # ❌ Allows public policies
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_iam_policy" "bad_policy" {
  name        = "bad-policy"
  description = "Terrible IAM policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"            # ❌ Allows all AWS IAM Actions
        Resource = "*"            # ❌ Allows access to everything
      }
    ]
  })
}

