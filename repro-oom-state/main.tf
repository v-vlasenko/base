resource "null_resource" "base" {
  triggers = {
    value = "initial"
  }
}

output "state_marker" {
  value = "master-branch-state"
}
