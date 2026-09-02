terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-network"
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

variable "name_prefix" {
  type = string
}

resource "random_integer" "octet" {
  count = 3
  min   = 0
  max   = 255
}

resource "terraform_data" "vpc" {
  input = {
    prefix = var.name_prefix
    cidr   = "10.0.0.0/16"
  }
}

output "vpc_cidr" {
  value = terraform_data.vpc.output.cidr
}

output "subnets" {
  value = [for i in random_integer.octet : "10.0.${i.result}.0/24"]
}

output "name_prefix" {
  value = var.name_prefix
}
