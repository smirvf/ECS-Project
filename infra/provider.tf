terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30.0"
    }
  }
  backend "s3" {
    bucket       = "smvf-s3-bucket-test"
    key          = "ecs-proj/infra/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

# Placeholder text to test trivy ignore changes