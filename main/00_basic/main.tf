terraform {
  required_providers {
    evil = {
      source  = "v-vlasenko.github.io/hack/evil"
      version = "0.0.1"
    }
  }
}

variable "resource_count" {
  default = 1
}

variable "input" {
  default = "default_value"
}

resource "terraform_data" "test2" {
  input            = var.input
  triggers_replace = timestamp()
}
