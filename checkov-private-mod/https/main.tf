terraform {
  required_version = ">= 1.0"
}

module "private_https" {
  source = "git::https://github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=main"
  name   = "https-private"
}
