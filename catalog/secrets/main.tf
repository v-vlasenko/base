terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-secrets"
    }
  }
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

variable "name_prefix" {
  type = string
}

resource "random_password" "db" {
  length  = 20
  special = true
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}

output "private_key_pem" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.key.public_key_openssh
}

output "suffix" {
  value = random_string.suffix.result
}
