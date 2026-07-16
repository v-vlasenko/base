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
  default = "team-x"
}

locals {
  base_tags = {
    Environment = "test"
    ManagedBy   = "scalr"
  }
  eu_tags = {
    Region = "eu"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = merge(local.base_tags, { Extra = var.extra_tag })
  }
}

provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
  default_tags {
    tags = merge(local.eu_tags, { Extra = var.extra_tag })
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "b" {
  bucket = "sc39118-a-${random_id.suffix.hex}"
}

moved {
  from = aws_s3_bucket.a
  to   = aws_s3_bucket.b
}

resource "aws_s3_bucket" "c" {
  bucket = "sc39118-c-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "e" {
  provider = aws.eu
  bucket   = "sc39118-e-${random_id.suffix.hex}"
}
