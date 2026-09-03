resource "random_pet" "producer" {
  length = 2
}
output "pet" {
  value = random_pet.producer.id
}
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
