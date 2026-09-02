resource "random_pet" "keep" {
  length = 2
}

output "id" {
  value = random_pet.keep.id
}
