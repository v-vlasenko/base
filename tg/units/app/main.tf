variable "app_env" {
  default = "dev"
}

variable "region" {
  default = "us-east-1"
}

resource "null_resource" "app" {}
