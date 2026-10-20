terraform {
  required_providers {
    aws  = { source = "hashicorp/aws", version = "6.57.1" }
    null = { source = "hashicorp/null", version = "3.2.4" }
  }
}

variable "environment" {
  type    = string
  default = "qa-prod"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = { Environment = var.environment }
  }
}

resource "null_resource" "n" {}
