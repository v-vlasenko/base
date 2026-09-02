terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-firewall"
    }
  }
}

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

variable "subnets" {
  type = list(string)
}

resource "null_resource" "rule" {
  count = length(var.subnets)
  triggers = {
    cidr = var.subnets[count.index]
  }
}

resource "null_resource" "summary" {
  triggers = {
    count = length(var.subnets)
  }
  provisioner "local-exec" {
    command = "echo firewall configured for ${length(var.subnets)} subnets"
  }
}

output "rule_count" {
  value = length(var.subnets)
}
