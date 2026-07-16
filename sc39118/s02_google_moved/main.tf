terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

variable "extra" {
  type    = string
  default = "team-y"
}

locals {
  common = {
    team = "core"
    env  = "test"
  }
}

provider "google" {
  default_labels = merge(local.common, { extra = var.extra })
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "new" {
  name          = "sc39118-g-${random_id.suffix.hex}"
  location      = "us-central1"
  storage_class = "STANDARD"
  force_destroy = true
}

moved {
  from = google_storage_bucket.old
  to   = google_storage_bucket.new
}
