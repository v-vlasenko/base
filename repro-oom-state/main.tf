resource "null_resource" "base" {
  triggers = {
    value = "initial"
  }
}

resource "null_resource" "many" {
  count = 500000

  triggers = {
    index = count.index
  }
}

output "state_marker" {
  value = "pr-branch-oom-test"
}
