terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-foundation"
    }
  }
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "name" {
  length = 2
}

resource "random_id" "env" {
  byte_length = 4
}

output "name_prefix" {
  value = "${random_pet.name.id}-${random_id.env.hex}"
}
