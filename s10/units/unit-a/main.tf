terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_id" "a" {
  byte_length = 4
}

output "id" {
  value = random_id.a.hex
}
