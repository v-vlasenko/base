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

# Deliberately collides with the probe's synthetic data source address
# (data.aws_default_tags.scalr_aws_default_tags_default) that
# tacolib.aws_default_tags.render_probe_config() injects for the
# unaliased/default provider. When the probe writes its own .tf.json into this
# same working directory, Terraform will see two declarations of the same
# data resource address and fail with "Duplicate data resource" - but only for
# the probe's own targeted plan invocation, since the probe's extra file is
# never present during the main plan/apply.
data "aws_default_tags" "scalr_aws_default_tags_default" {}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "old" {
  bucket = "sc39118-s09v2-${random_id.suffix.hex}"
}
