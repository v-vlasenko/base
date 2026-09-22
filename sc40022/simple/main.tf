terraform {
  required_providers {
    null = { source = "hashicorp/null", version = "~> 3.0" }
  }
}

resource "null_resource" "sc40022" {
  triggers = { run = timestamp() }
}

output "ok" {
  value = "sc40022-simple"
}