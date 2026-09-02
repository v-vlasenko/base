resource "random_pet" "a" {
  length = 2
}

output "id" {
  value = random_pet.a.id
}
