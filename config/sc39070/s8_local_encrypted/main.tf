terraform {
  encryption {
    key_provider "pbkdf2" "k" {
      passphrase = "sc39070-s8-passphrase-not-a-secret-0000"
    }
    method "aes_gcm" "m" {
      keys = key_provider.pbkdf2.k
    }
    state {
      method = method.aes_gcm.m
    }
  }
  backend "local" {}
}

resource "terraform_data" "enc8" {
  input = "sc39070-s8-disabled-backend-encrypted-state-probe"
}

output "probe8" {
  value = terraform_data.enc8.output
}
