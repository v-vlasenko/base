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

resource "terraform_data" "this" {
  triggers_replace = timestamp()
}

output "var1_value" {
  value = var.var1
}

output "var2_value" {
  value = var.var2
}

# PR trigger for item 17 test
