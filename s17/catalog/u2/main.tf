resource "random_pet" "u2" {
  length = 2
}

output "id" {
  value = random_pet.u2.id
}
