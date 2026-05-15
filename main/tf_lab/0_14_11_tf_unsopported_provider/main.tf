terraform {
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }
  }
}

resource "terraform_data" "example" {}