terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-monitoring"
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

resource "random_pet" "monitoring" {
  length = 2
}

output "monitoring" {
  value = random_pet.monitoring.id
}
