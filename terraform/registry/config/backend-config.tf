bucket         = "terraform-states"
key            = "cicd-pipeline.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-locks"
