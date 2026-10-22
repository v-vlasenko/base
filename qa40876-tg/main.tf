variable "big" { type = number }
resource "terraform_data" "t" { input = var.big }
output "big" { value = var.big }
