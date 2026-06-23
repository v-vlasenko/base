terraform {
  required_version = ">= 1.0"
}

module "parent" {
  source = "git::https://github.com/v-vlasenko/checkov-private-module.git//modules/parent?ref=main"
}
