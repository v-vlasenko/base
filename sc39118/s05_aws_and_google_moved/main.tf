terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

variable "extra_tag" {
  type    = string
  default = "team-s05"
}

locals {
  aws_tags     = { Environment = "test" }
  google_labels = { team = "core" }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = merge(local.aws_tags, { Extra = var.extra_tag })
  }
}

provider "google" {
  default_labels = merge(local.google_labels, { extra = var.extra_tag })
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "old" {
  bucket = "sc39118-s05-aws-${random_id.suffix.hex}"
}

resource "google_storage_bucket" "old" {
  name          = "sc39118-s05-gcs-${random_id.suffix.hex}"
  location      = "us-central1"
  storage_class = "STANDARD"
  force_destroy = true
}
