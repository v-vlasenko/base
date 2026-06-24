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
  common_labels = {
    team        = var.team
    env         = "user_value"
    dynamic_key = "resolved_dynamically"
  }
}

# Dynamic default_labels: references locals + a merge() the static HCL parser cannot evaluate.
provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common_labels, { extra = "merged_${var.team}" })
}

# Observation point: returns the provider's FINAL default_labels (after Scalr override merge).
data "google_client_config" "observe" {}

output "effective_default_labels" {
  value = data.google_client_config.observe.default_labels
}
