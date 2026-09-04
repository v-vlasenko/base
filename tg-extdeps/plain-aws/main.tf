terraform {
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
  name  = "/scalr-plain-test/1788497675/a"
  type  = "String"
  tier  = "Standard"
  value = "scalr-plain-free-test"
}
output "param_arn" {
  value = aws_ssm_parameter.test.arn
}
