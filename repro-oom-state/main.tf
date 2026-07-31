resource "null_resource" "base" {
  triggers = {
    value = "initial"
  }
}

resource "null_resource" "from_pr" {
  triggers = {
    value = "added-by-pr-branch"
  }
}

output "state_marker" {
  value = "pr-branch-state"
}
