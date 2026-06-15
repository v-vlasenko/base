terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

locals {
  common_labels = {
    owner = "user-dynamic"
    team  = "platform"
  }
}

provider "google" {
  default_labels = local.common_labels
}

resource "google_storage_bucket" "test" {
  name          = "scalr-lbl-test-s22"
  location      = "US"
  force_destroy = true
}

resource "null_resource" "empty" {}
