resource "random_pet" "a" {
  length = 2
}
output "n" {
  value = random_pet.a.id
}
