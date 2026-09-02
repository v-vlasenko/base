terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_id" "b" {
  byte_length = 4
}

output "id" {
  value = random_id.b.hex
}
