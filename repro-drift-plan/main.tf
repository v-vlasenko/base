provider "aws" {
  region = "us-east-1"
}

variable "sg_name" {
  default = "repro-cloud-5047-drift"
}

resource "aws_security_group" "repro" {
  name        = var.sg_name
  description = "Repro for CLOUD-5047 - state push during dry plan"

  tags = {
    Name = "repro-cloud-5047"
    ManagedBy = "terraform"
  }
}

output "sg_id" {
  value = aws_security_group.repro.id
}

output "state_marker" {
  value = "master-branch-base"
}
