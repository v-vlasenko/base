terraform {
  required_providers {
    aws      = { source = "hashicorp/aws" }
    external = { source = "hashicorp/external" }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "this" {}

# JWT payload segment only (no signature) of the AWS web identity token.
data "external" "token" {
  program = ["bash", "-c", "p=$(cut -d. -f2 \"$AWS_WEB_IDENTITY_TOKEN_FILE\"); echo \"{\\\"p\\\":\\\"$p\\\"}\""]
}

locals {
  p      = replace(replace(data.external.token.result.p, "-", "+"), "_", "/")
  claims = jsondecode(base64decode("${local.p}${substr("===", 0, (4 - length(local.p) % 4) % 4)}"))
}

output "arn" {
  value = data.aws_caller_identity.this.arn
}

output "claims" {
  value = local.claims
}
