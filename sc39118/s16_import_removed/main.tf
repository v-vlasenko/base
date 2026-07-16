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
  default = "team-s16"
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
  bucket = "sc39118-s16-new-${random_id.suffix.hex}"
}

moved {
  from = aws_s3_bucket.old
  to   = aws_s3_bucket.new
}

# Config-driven import block (TF/OpenTofu 1.5+): the fix does not add its
# addresses to the probe's -target list.
import {
  to = aws_s3_bucket.imported
  id = "sc39118-s16-does-not-exist-in-aws"
}

resource "aws_s3_bucket" "imported" {
  bucket = "sc39118-s16-imported-${random_id.suffix.hex}"
}
