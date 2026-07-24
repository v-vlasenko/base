# SCALRCORE-39070 S1: WIDE plan -> large `show -json` output, light on the tofu
# planner. One shared ~4 KiB blob referenced by many cheap built-in
# terraform_data resources (no provider process). ~20000 resources => ~160 MiB
# plan JSON, while tofu keeps the blob once and the nodes are lightweight.
terraform {
  required_providers {
    terraform = {}
  }
}

locals {
  c64  = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
  blob = join("", [for i in range(0, 64) : local.c64]) # 4096 bytes
}

resource "terraform_data" "wide" {
  count = 20000
  input = local.blob
}

output "count" {
  value = length(terraform_data.wide)
}
