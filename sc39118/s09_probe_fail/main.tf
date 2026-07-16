terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  base_tags = {
    Environment = "test"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    # Deliberately invalid expression (division by zero) so the probe's targeted
    # plan genuinely fails for a non-"moved" reason.
    tags = merge(local.base_tags, { Bad = tostring(1 / 0) })
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "new" {
  bucket = "sc39118-s09-new-${random_id.suffix.hex}"
}

moved {
  from = aws_s3_bucket.old
  to   = aws_s3_bucket.new
}
