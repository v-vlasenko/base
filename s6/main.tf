terraform {
  required_providers { random = { source = "hashicorp/random" } }
}
resource "random_pet" "s6" { length = 2 }
output "name" { value = random_pet.s6.id }
