terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "awsbe-1788454078-ssma"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_ssm_parameter" "test" {
  name  = "/scalr-tg-stack-test/1788454078/a"
  type  = "String"
  tier  = "Standard"
  value = "scalr-tg-stack-free-test"
}
output "param_arn" {
  value = aws_ssm_parameter.test.arn
}
