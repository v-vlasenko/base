resource "random_pet" "u1" {
  length = 2
}

output "id" {
  value = random_pet.u1.id
}
