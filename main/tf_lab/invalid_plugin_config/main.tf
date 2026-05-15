terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

provider "vault" {
  address = "http://255.255.255.255:8200"
  token   = "fake-token"
}

data "vault_generic_secret" "test" {
  path = "secret/billing-test"
}

resource "vault_generic_secret" "test" {
  path      = "secret/billing-test"
  data_json = jsonencode({ key = "value" })
}