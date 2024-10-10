resource "null_resource" "test" {
  count = var.quantity
  # triggers = {
  #   trigger = timestamp()
  # }
}

variable "quantity" {
  type        = number
  description = "Number of resources to be created"
