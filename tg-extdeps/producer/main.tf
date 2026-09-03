terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "extbe-1788439157-s34-producer"
    }
  }
}
resource "random_pet" "producer" {
  length = 2
}
output "pet" {
  value = random_pet.producer.id
}
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
