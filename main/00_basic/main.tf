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

variable "servers" {
  type    = list(string)
  default = []
}

variable "final_val" {
  default = "default_final"
}

variable "empty_sensitive" {
  sensitive = true
  default   = ""
}

variable "auto_only" {
  default = "tf_default"
  description = "Only set in auto.tfvars, not in Scalr vars"
}

resource "terraform_data" "test2" {
  input            = var.input
  triggers_replace = timestamp()
}

resource "null_resource" "empty" {}
