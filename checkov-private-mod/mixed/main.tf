terraform {
  required_version = ">= 1.0"
}

module "private_https" {
  source = "git::https://github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=v0.0.1"
  name   = "mixed-https"
}

module "private_ssh" {
  source = "git::ssh://git@github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=v0.0.1"
  name   = "mixed-ssh"
}
