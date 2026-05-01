variable "var1" {
  default = ""
}
variable "var2" {
  default = ""
}
variable "var_hcl" {
  type    = any
  default = null
}
variable "var_a" {
  default = ""
}
variable "var_b" {
  default = ""
}
variable "var_c" {
  default = ""
}

resource "terraform_data" "this" {
  triggers_replace = timestamp()
}

output "var1_value" { value = var.var1 }
output "var2_value" { value = var.var2 }
output "var_a_value" { value = var.var_a }
output "var_b_value" { value = var.var_b }
output "var_c_value" { value = var.var_c }
