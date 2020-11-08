provider "aws" {
  version    = "~> 3.3.0"
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}
