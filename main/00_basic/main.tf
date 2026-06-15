terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # PC labels should inject here
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {}
  }
}

resource "google_storage_bucket" "test" {
  name          = "scalr-lbl-s28-scenario"
  location      = "US"
  force_destroy = true
}

resource "null_resource" "empty" {}
