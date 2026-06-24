terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

locals {
  empty_labels = {}
}

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = local.empty_labels
}

data "google_client_config" "default" {}

output "default_labels" {
  value = data.google_client_config.default.default_labels
}
