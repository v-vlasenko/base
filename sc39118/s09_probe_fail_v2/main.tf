terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "extra_tag" {
  type    = string
  default = "team-s09v2"
}

locals {
  base_tags = {
    Environment = "test"
    ManagedBy   = "scalr"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = merge(local.base_tags, { Extra = var.extra_tag })
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "new" {
  bucket = "sc39118-s09v2-${random_id.suffix.hex}"
}

moved {
  from = aws_s3_bucket.old
  to   = aws_s3_bucket.new
}
