resource "random_pet" "solo" {
  length = 2
}
output "n" {
  value = random_pet.solo.id
}
