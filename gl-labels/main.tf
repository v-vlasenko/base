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

provider "google" {
  project        = "fluent-cyclist-443522-q4"
  region         = "us-central1"
  default_labels = merge(local.common_labels, { extra = "merged_${var.team}" })
}

data "google_client_config" "observe" {}

output "effective_default_labels" {
  value = data.google_client_config.observe.default_labels
}
