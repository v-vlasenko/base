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

variable "extra_tag" {
  type    = string
  default = "team-s10"
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
  bucket = "sc39118-s10-new-${random_id.suffix.hex}"
}

# Malformed: missing "to" (incomplete moved block)
moved {
  from = aws_s3_bucket.only_from
}

# Valid moved block alongside the malformed one
moved {
  from = aws_s3_bucket.old
  to   = aws_s3_bucket.new
}
