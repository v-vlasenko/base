terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  default_labels = {
    owner = "user-hcl"
  }
}

resource "null_resource" "empty" {}
