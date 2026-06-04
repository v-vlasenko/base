terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 3.43.0" }
    random = { source = "hashicorp/random" }
  }
}
locals { common_tags = { Team = "platform" } }
provider "aws" {
  region = "us-east-1"
  default_tags { tags = local.common_tags }
}
resource "random_pet" "n" { length = 2 }
resource "aws_iam_role" "test" {
  name = "scalr-aws-tags-s01-${random_pet.n.id}"
  assume_role_policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Principal={Service="ec2.amazonaws.com"},Action="sts:AssumeRole"}]})
  tags = { Purpose = "scalr-test" }
}
# s37-trigger
