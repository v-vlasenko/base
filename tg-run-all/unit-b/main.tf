resource "terraform_data" "unit_b" {
  input = "unit-b"
}

output "unit" {
  value = terraform_data.unit_b.output
}
