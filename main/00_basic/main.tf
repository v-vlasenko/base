terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # default provider — PC labels should patch this one
}

provider "google" {
  alias = "europe"
  # aliased provider — should NOT be patched by default PCFG link
}

resource "google_storage_bucket" "test" {
  name          = "scalr-lbl-s23-scenario"
  location      = "US"
  force_destroy = true
}

resource "null_resource" "empty" {}
