# Load fixture for the run-queue write amplification repro.
# terraform_data needs no provider credentials and always plans a change.
resource "terraform_data" "load" {
  triggers_replace = var.tick
}

variable "tick" {
  type    = string
  default = "0"
}
