resource "random_pet" "consumer" {
  length = 2
}
output "consumer" {
  value = random_pet.consumer.id
}
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
