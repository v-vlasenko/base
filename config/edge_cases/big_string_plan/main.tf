# SCALRCORE-39070 S1: large plan JSON to stress `show -json` worker memory.
# ~512 resources x ~320 KiB string  => ~160 MiB in planned_values plus
# an equal amount in resource_changes.after  => ~330 MiB plan JSON.
terraform {
  required_providers {
    terraform = {}
  }
}

locals {
  # 64-char chunk; 5120 * 64 = 327680 bytes = 320 KiB per resource.
  chunk = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
  big   = join("", [for i in range(0, 5120) : local.chunk])
}

resource "terraform_data" "big" {
  count = 512
  input = "${count.index}-${local.big}"
}

output "count" {
  value = length(terraform_data.big)
}
