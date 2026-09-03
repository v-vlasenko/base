terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "extbe-1788439157-s28-a"
    }
  }
}
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
resource "random_pet" "this" {
  length = 2
}
output "name" {
  value = random_pet.this.id
}
