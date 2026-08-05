terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_caller_identity" "secondary" {
  provider = aws.secondary
}

output "region" {
  value = data.aws_region.current.name
}

output "secondary_account_id" {
  value = data.aws_caller_identity.secondary.account_id
}
