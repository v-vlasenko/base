terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # no default_labels
}

resource "google_storage_bucket" "test" {
  name          = "scalr-lbl-test-s21"
  location      = "US"
  force_destroy = true
}

resource "null_resource" "empty" {}
