resource "random_pet" "b" {
  length = 2
}

output "id" {
  value = random_pet.b.id
}
