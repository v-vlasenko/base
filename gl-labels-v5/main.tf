terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
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

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common_labels, { extra = "merged_${var.team}" })
}

# google < 5.43 has no default_labels on data source, so observe via a resource's terraform_labels.
resource "google_storage_bucket" "observe" {
  name                        = "scalrcore-38991-gl-v5-observe"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels = {
    explicit = "on_resource"
  }
}
