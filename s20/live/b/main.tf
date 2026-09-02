resource "random_pet" "b" {
  length = 2
}
output "n" {
  value = random_pet.b.id
}
