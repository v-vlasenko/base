resource "null_resource" "base" {
  triggers = {
    value = "initial"
  }
}

resource "null_resource" "many" {
  for_each = toset([for i in range(0, 500000) : "resource-${i}"])

  triggers = {
    index = each.key
  }
}

output "state_marker" {
  value = "pr-branch-oom-test"
}
