terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }
}

locals {
  environment = "production"
  provider_labels = {
    efg_gg_team = "devxp"
    efg_gg_env  = local.environment
  }
}

provider "google" {
  default_labels = local.provider_labels
}

resource "google_storage_bucket" "repro" {
  name                        = "scalr-39964-repro-old"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}
