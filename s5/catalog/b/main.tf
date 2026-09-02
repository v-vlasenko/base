terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "s5vcs-b-1788385584"
    }
  }
}

resource "random_pet" "b" {
  length = 2
}

output "id" {
  value = random_pet.b.id
}
