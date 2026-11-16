variable "sleep" {
  type    = string
  default = "1s"
}

resource "time_sleep" "wait" {
  create_duration = var.sleep
  triggers        = { t = timestamp() }
}

resource "terraform_data" "this" {
  triggers_replace = timestamp()
}
