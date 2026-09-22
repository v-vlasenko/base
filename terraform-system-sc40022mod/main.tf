terraform {
  required_version = ">= 1.0"
}

locals {
  greeting = "hello ${var.name}"
}