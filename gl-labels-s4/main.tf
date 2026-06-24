terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = { env = "prod", owner = "qe" }
}

data "google_client_config" "default" {}

output "default_labels" {
  value = data.google_client_config.default.default_labels
}
