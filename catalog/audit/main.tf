terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-audit"
    }
  }
}

terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

variable "name_prefix" {
  type = string
}

resource "time_static" "created" {}

resource "time_rotating" "rotate" {
  rotation_days = 30
}

resource "terraform_data" "tag" {
  input = {
    name    = var.name_prefix
    created = time_static.created.rfc3339
  }
}

output "created_at" {
  value = time_static.created.rfc3339
}

output "rotate_at" {
  value = time_rotating.rotate.rfc3339
}
