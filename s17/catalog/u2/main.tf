terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "s17vcs-u2-1788385584"
    }
  }
}

resource "random_pet" "u2" {
  length = 2
}

output "id" {
  value = random_pet.u2.id
}
