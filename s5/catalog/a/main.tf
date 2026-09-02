terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "s5vcs-a-1788385584"
    }
  }
}

resource "random_pet" "a" {
  length = 2
}

output "id" {
  value = random_pet.a.id
}
