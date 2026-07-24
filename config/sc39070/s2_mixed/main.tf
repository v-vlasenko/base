# SCALRCORE-39070 S2 baseline (v1): resources to later update/replace/move/destroy.
terraform {
  required_providers {
    terraform = {}
  }
}

resource "terraform_data" "keep"     { input = "v1" }          # -> in-place update later
resource "terraform_data" "to_repl"  { input = "r"
  triggers_replace = ["t1"] }                                   # -> replace later
resource "terraform_data" "old_name" { input = "m" }           # -> moved later
resource "terraform_data" "to_destroy" { input = "gone" }      # -> destroyed later
