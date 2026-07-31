resource "null_resource" "base" {
  triggers = {
    value = "initial"
  }
}

data "external" "oom_trigger" {
  program = ["python3", "${path.module}/oom.py"]
}

output "state_marker" {
  value = "pr-branch-oom-test"
}
