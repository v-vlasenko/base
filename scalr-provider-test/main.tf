terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-SCALRCORE-37731"
    }
  }
}

provider "scalr" {}

variable "google_credentials" {
  sensitive = true
}
