terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-SCALRCORE-37731"
    }
  }
}

provider "scalr" {}

# CREATE: Google PC with default_labels block + strategy skip
resource "scalr_provider_configuration" "google_labels_skip" {
  name                   = "tf-provider-test-skip"
  account_id             = "acc-svrcncgh453bi8g"
  export_shell_variables = false

  google {
    credentials = var.google_credentials

    default_labels {
      labels = {
        env   = "prod"
        owner = "scalr-tf"
        team  = "platform"
      }
      strategy = "skip"
    }
  }
}

# CREATE: Google PC with default_labels block + strategy update
resource "scalr_provider_configuration" "google_labels_update" {
  name                   = "tf-provider-test-update"
  account_id             = "acc-svrcncgh453bi8g"
  export_shell_variables = false

  google {
    credentials = var.google_credentials

    default_labels {
      labels = {
        env   = "staging"
        owner = "scalr-tf"
      }
      strategy = "update"
    }
  }
}

# CREATE: Google PC without default_labels block (no labels configured)
resource "scalr_provider_configuration" "google_no_labels" {
  name                   = "tf-provider-test-nolabels"
  account_id             = "acc-svrcncgh453bi8g"
  export_shell_variables = false

  google {
    credentials = var.google_credentials
  }
}

variable "google_credentials" {
  sensitive = true
}

output "pcfg_skip_id" {
  value = scalr_provider_configuration.google_labels_skip.id
}

output "pcfg_update_id" {
  value = scalr_provider_configuration.google_labels_update.id
}

output "pcfg_no_labels_id" {
  value = scalr_provider_configuration.google_no_labels.id
}
