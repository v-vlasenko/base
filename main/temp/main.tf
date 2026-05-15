resource "null_resource" "nullable_trigger" {
  triggers = {
    example_variable = var.nullable != null ? var.nullable : "default_value"
  }
}

variable "nullable" {
  type     = string
  nullable = true
  sensitive = true
}