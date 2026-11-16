variable "sleep" {
  type    = string
  default = "0"
}

data "external" "sleep" {
  program = ["bash", "-c", "sleep ${var.sleep}; echo '{\"ok\":\"1\"}'"]
}

resource "terraform_data" "this" {
  input            = data.external.sleep.result.ok
  triggers_replace = timestamp()
}
