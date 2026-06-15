variable "resource_count" {
  default = 1
}

variable "input" {
  default = "default_value"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # no default_labels - PC labels should be injected
}

resource "null_resource" "empty" {}
