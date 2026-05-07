variable "resource_count" {
  default = 1
}

variable "input" {
  default = "default_value"
}

resource "terraform_data" "test" {
  count = var.resource_count
  
  input = {
    index = count.index
    timestamp = timestamp()
    random = uuid()
    description = "Test resource ${count.index} for blob writer testing"
  }
  
  # Force recreation on each apply to generate maximum output
  triggers_replace = [
    timestamp()
  ]
}

resource "terraform_data" "test2" {
  input = var.input
  triggers_replace = timestamp()
}

output "test2" {
  value = terraform_data.test2.output
}
