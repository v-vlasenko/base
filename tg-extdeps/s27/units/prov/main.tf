terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
resource "random_pet" "this" {
  length = 2
}
output "name" {
  value = random_pet.this.id
}
