terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

locals {
  common = { team = "core", env = "s13" }
}

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common, { extra = "merged_${local.common.team}" })
}

# No google data sources or resources - probe fails, main plan succeeds
output "check" {
  value = "s13_probe_fallback_test"
}
