terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "smvf-s3-bucket-test"
    key          = "ecs-proj/s3-boostrap/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "s3_bucket_tf_state"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_block" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "acl_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}