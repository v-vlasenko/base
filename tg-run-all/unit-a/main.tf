resource "terraform_data" "unit_a" {
  input = "unit-a"
}

output "unit" {
  value = terraform_data.unit_a.output
}
