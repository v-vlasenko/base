terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

locals {
  common = { team = "core", env = "s23" }
}

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common, { scenario = "no_pcfg" })
}

data "google_client_config" "default" {}

output "default_labels" {
  value = data.google_client_config.default.default_labels
}
