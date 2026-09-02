terraform {
  required_providers { random = { source = "hashicorp/random" } }
}
resource "random_pet" "x" {
  length = 2
# missing closing brace below -> HCL syntax error
output "n" { value = random_pet.x.id }
