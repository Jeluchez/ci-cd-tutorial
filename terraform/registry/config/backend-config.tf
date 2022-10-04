bucket                  = "terraform-state"
key                     = "terraform.tfstate"
region                  = "us-east-1"
encrypt                 = true
dynamodb_table          = "terraform-locks"
shared_credentials_file = "/Users/joseluis.sanchez/.aws/credentials"
