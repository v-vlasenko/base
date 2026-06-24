terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

variable "team" {
  type    = string
  default = "core"
}

locals {
  common = {
    team = var.team
    env  = "user_value"
  }
}

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common, { extra = "merged_${var.team}" })
}

provider "google" {
  alias          = "europe"
  project        = "fluent-cyclist-443522-q4"
  region         = "europe-west1"
  default_labels = { geo = "user_eu", squad = local.common.team }
}

data "google_client_config" "default" {}
data "google_client_config" "europe" {
  provider = google.europe
}

output "default_labels" {
  value = data.google_client_config.default.default_labels
}

output "europe_labels" {
  value = data.google_client_config.europe.default_labels
}
