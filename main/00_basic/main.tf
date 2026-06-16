variable "resource_count" {
  default = 1
}

variable "input" {
  default = "default_value"
}

variable "secret_val" {
  sensitive = true
  default   = ""
}

resource "terraform_data" "test2" {
  input            = var.input
  triggers_replace = timestamp()
}

resource "null_resource" "empty" {}