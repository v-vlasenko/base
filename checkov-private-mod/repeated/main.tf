terraform {
  required_version = ">= 1.0"
}

module "first" {
  source = "git::https://github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=v0.0.1"
  name   = "first"
}

module "second" {
  source = "git::https://github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=v0.0.1"
  name   = "second"
}
