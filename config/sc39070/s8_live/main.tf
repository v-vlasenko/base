terraform {
  encryption {
    key_provider "pbkdf2" "k" {
      passphrase = "sc39070-s8-live-passphrase-not-a-secret-0000"
    }
    method "aes_gcm" "m" {
      keys = key_provider.pbkdf2.k
    }
    state {
      method = method.aes_gcm.m
    }
  }

  backend "s3" {
    bucket = "scalr-e2e-tg-test"
    key    = "sc39070/s8-live/674416948/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "terraform_data" "enc8_live" {
  input = "sc39070-s8-live-disabled-remote-backend"
}

output "probe8_live" {
  value = terraform_data.enc8_live.output
}
