variable "big" { type = number }
resource "terraform_data" "t" { input = var.big }
output "big" { value = var.big }
# trigger 2026-10-22T08:05:59Z
