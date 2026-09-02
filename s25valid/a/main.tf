terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "s25v-a-1788393321"
    }
  }
}

resource "random_pet" "n" {
  length = 2
}

output "id" {
  value = random_pet.n.id
}

