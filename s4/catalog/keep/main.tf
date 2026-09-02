terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "s4vcs-keep-1788385584"
    }
  }
}

resource "random_pet" "keep" {
  length = 2
}

output "id" {
  value = random_pet.keep.id
}
