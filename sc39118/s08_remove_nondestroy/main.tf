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
  default = "team-s08"
}

locals {
  base_tags = { Environment = "test" }
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

resource "aws_s3_bucket" "keep" {
  bucket = "sc39118-s08-keep-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "remove_me" {
  bucket = "sc39118-s08-removeme-${random_id.suffix.hex}"
}
