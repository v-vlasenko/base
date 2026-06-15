terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-SCALRCORE-37731"
    }
  }
}

provider "scalr" {}

# CREATE: Google PC with default_labels and strategy skip
resource "scalr_provider_configuration" "google_labels_skip" {
  name           = "tf-provider-test-skip"
  account_id     = "acc-svrcncgh453bi8g"
  export_shell_variables = false

  google {
    credentials = var.google_credentials
    default_labels = {
      env   = "prod"
      owner = "scalr-tf"
      team  = "platform"
    }
    default_label_strategy = "skip"
  }
}

# CREATE: Google PC with strategy update
resource "scalr_provider_configuration" "google_labels_update" {
  name           = "tf-provider-test-update"
  account_id     = "acc-svrcncgh453bi8g"
  export_shell_variables = false

  google {
    credentials = var.google_credentials
    default_labels = {
      env   = "staging"
      owner = "scalr-tf"
    }
    default_label_strategy = "update"
  }
}

# CREATE: Google PC with empty labels
resource "scalr_provider_configuration" "google_labels_empty" {
  name           = "tf-provider-test-empty"
  account_id     = "acc-svrcncgh453bi8g"
  export_shell_variables = false

  google {
    credentials = var.google_credentials
    default_labels = {}
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

output "pcfg_empty_id" {
  value = scalr_provider_configuration.google_labels_empty.id
}
