# SCALRCORE-39070 S1: large plan JSON to stress `show -json` worker memory.
# 512 resources x ~320 KiB string => ~160 MiB planned_values + equal in
# resource_changes.after => ~330 MiB plan JSON. range() capped at 1024 in tofu,
# so the big string is built from nested joins.
terraform {
  required_providers {
    terraform = {}
  }
}

locals {
  c64 = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
  c1k = join("", [for i in range(0, 16) : local.c64])   # 1024 bytes
  big = join("", [for i in range(0, 320) : local.c1k])  # 320 KiB
}

resource "terraform_data" "big" {
  count = 512
  input = "${count.index}-${local.big}"
}

output "count" {
  value = length(terraform_data.big)
}
