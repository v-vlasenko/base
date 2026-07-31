resource "null_resource" "base" {
  triggers = {
    value = "initial"
  }
}

# Generate a massive list to consume memory during plan evaluation
locals {
  # Each level doubles memory: 50000 * 200 chars = ~10MB per level
  # With nested maps and repeated operations, this should push memory high
  big_list = [for i in range(0, 200000) : {
    key   = "item-${i}"
    value = "data-${i}-${"x" == "x" ? join(",", [for j in range(0, 50) : "padding-${j}"]) : ""}"
    nested = {
      a = "value-a-${i}"
      b = "value-b-${i}"
      c = [for k in range(0, 20) : "nested-${i}-${k}"]
    }
  }]

  # Force evaluation by using the result
  big_count = length(local.big_list)
}

output "state_marker" {
  value = "pr-branch-oom-test-${local.big_count}"
}
