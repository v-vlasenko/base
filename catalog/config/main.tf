terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-config"
    }
  }
}

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "name_prefix" {
  type = string
}

variable "subnets" {
  type = list(string)
}

resource "local_file" "cfg" {
  filename = "${path.module}/rendered.cfg"
  content  = jsonencode({ prefix = var.name_prefix, subnets = var.subnets })
}

output "config_path" {
  value = local_file.cfg.filename
}

output "rendered" {
  value = local_file.cfg.content
}
