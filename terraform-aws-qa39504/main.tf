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
  default = "dev"
}

resource "aws_s3_bucket" "example" {
  bucket = "qa39504-module-example"
}

output "tags_all" {
  value = aws_s3_bucket.example.tags_all
}
