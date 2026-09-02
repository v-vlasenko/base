terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "s19vcs-app-1788382171"
    }
  }
}

resource "random_pet" "app" {
  length = 2
}

output "id" {
  value = random_pet.app.id
}
