# SCALRCORE-39070 S2 mixed (v2): add + in-place change + replace + move + import + destroy.
terraform {
  required_providers {
    terraform = {}
  }
}

# in-place update: input v1 -> v2
resource "terraform_data" "keep" {
  input = "v2"
}

# replace (-/+): triggers_replace changed
resource "terraform_data" "to_repl" {
  input            = "r"
  triggers_replace = ["t2"]
}

# move: old_name -> new_name
resource "terraform_data" "new_name" {
  input = "m"
}

moved {
  from = terraform_data.old_name
  to   = terraform_data.new_name
}

# to_destroy removed from config -> destroy

# add: brand new resource
resource "terraform_data" "added" {
  input = "new"
}

# import: bring an out-of-band resource under management
import {
  to = terraform_data.imported
  id = "imported-seed-id"
}

resource "terraform_data" "imported" {
  input = "imp"
}
