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
  default = "team-s04"
}

locals {
  us_tags = {
    Environment = "test"
    Region      = "us"
  }
  eu_tags = {
    Environment = "test"
    Region      = "eu"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = merge(local.us_tags, { Extra = var.extra_tag })
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

resource "aws_s3_bucket" "new_us" {
  bucket = "sc39118-s04-us-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "new_eu" {
  provider = aws.eu
  bucket   = "sc39118-s04-eu-${random_id.suffix.hex}"
}

moved {
  from = aws_s3_bucket.old_us
  to   = aws_s3_bucket.new_us
}

moved {
  from = aws_s3_bucket.old_eu
  to   = aws_s3_bucket.new_eu
}
