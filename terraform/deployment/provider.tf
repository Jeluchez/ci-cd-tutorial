terraform {
  backend "s3" { /* See the backend config in config/backend-config.tf */ }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Application = var.service_name
      Terraform   = true
    }
  }
}
