terraform {
  required_providers {
    external = { source = "hashicorp/external" }
  }
}
variable "sleep" {
  type    = number
  default = 90
}
data "external" "slow" {
  program = ["bash", "-c", "sleep ${var.sleep}; echo '{\"ok\":\"1\"}'"]
}
resource "terraform_data" "r" {
  input = data.external.slow.result.ok
  provisioner "local-exec" {
    command = "sleep ${var.sleep}"
  }
}
output "done" { value = terraform_data.r.output }
# q39806 PR change
# q39806 PR change 2
