terraform {
  encryption {
    key_provider "pbkdf2" "k" {
      passphrase = "sc39070-test-passphrase-not-a-secret-000"
    }
    method "aes_gcm" "m" {
      keys = key_provider.pbkdf2.k
    }
    state {
      method = method.aes_gcm.m
    }
  }
}

resource "terraform_data" "enc" {
  input = "sc39070-encrypted-state-probe"
}

output "probe" {
  value = terraform_data.enc.output
}
