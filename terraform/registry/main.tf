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
  # shared_credentials_files = ["/Users/joseluis.sanchez/.aws/credentials"]
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = var.registry_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value       = aws_ecr_repository.my_ecr_repo.registry_id
}

output "repository_name" {
  description = "The name of the repository."
  value       = aws_ecr_repository.my_ecr_repo.name
}

output "repository_url" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.my_ecr_repo.repository_url
}
