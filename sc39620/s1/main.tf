terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "environment" {
  type    = string
  default = "live"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = var.environment
      Static      = "yes"
    }
  }
}


resource "aws_s3_bucket" "untouched" {}

resource "aws_s3_bucket" "movable" {
  count = 1
}

output "untouched_tags_all" { value = aws_s3_bucket.untouched.tags_all }
output "movable_tags_all" { value = aws_s3_bucket.movable[*].tags_all }
