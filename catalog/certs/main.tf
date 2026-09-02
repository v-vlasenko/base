terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "tgvcs-certs"
    }
  }
}

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

variable "common_name" {
  type = string
}

resource "tls_private_key" "ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem
  subject {
    common_name  = var.common_name
    organization = "Scalr Test"
  }
  validity_period_hours = 24
  allowed_uses          = ["cert_signing", "crl_signing", "digital_signature"]
  is_ca_certificate     = true
}

output "cert_pem" {
  value = tls_self_signed_cert.ca.cert_pem
}
