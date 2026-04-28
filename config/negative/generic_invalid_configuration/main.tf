# terraform {
#   required_version = ""
# }

# resource "null_resource" {
#   count = 7
#   triggers = {
#     always_run = timestamp()
#   }
# }

# resource "null_resource" {
#   count = 7
#   triggers = {
#     always_run = timestamp()
#   }
# }

resource "null_resource" "" {}

# resource "" "name" {}

# resource "null_resource" "example" = {
#   triggers = {
#     always_run = "Yes"
#   }
# }

# resource "null_resource" "example" {
#   triggers = {
#     value = "${var.non_existent_var}"
#   }
# }

# resource "null_resource" "example" {
#   resource "aws_instance" "nested" {
#     ami = "ami-123456"
#     instance_type = "t2.micro"
#   }
# }

# variable "" {
#   default = "string"
# }

# output "" {
#   value = "output"
# }

#comment