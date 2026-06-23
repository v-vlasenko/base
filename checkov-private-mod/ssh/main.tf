terraform {
  required_version = ">= 1.0"
}

module "private_ssh" {
  source = "git::ssh://git@github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=main"
  name   = "ssh-private"
}
