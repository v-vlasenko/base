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

# Dynamic default_labels: locals + merge() that the static HCL parser cannot evaluate.
provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common_labels, { extra = "merged_${var.team}" })
}

# Basic resource. On a create-plan, terraform_labels = resource labels + provider default_labels,
# so the merged (resolved user + Scalr) label set is visible in the plan diff. No API token needed.
resource "google_storage_bucket" "observe" {
  name                        = "scalrcore-38991-gl-labels-observe"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels = {
    explicit = "on_resource"
  }
}
