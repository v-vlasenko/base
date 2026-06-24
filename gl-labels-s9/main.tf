terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

locals {
  common = { team = "core" }
}

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common, { env = "user_default" })
}

provider "google" {
  alias          = "europe-west1"
  project        = "fluent-cyclist-443522-q4"
  region         = "europe-west1"
  default_labels = { geo = "user_eu_west1" }
}

data "google_client_config" "default" {}
data "google_client_config" "europe_west1" {
  provider = google.europe-west1
}

output "default_labels" {
  value = data.google_client_config.default.default_labels
}

output "europe_west1_labels" {
  value = data.google_client_config.europe_west1.default_labels
}
