terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "smvf-s3-bucket-test"
    region = "eu-west-2"
    key    = "tfstate/terraform.tfstate"
    use_lockfile = true
  }

}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}