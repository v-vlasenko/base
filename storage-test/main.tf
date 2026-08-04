resource "null_resource" "test" {
  triggers = {
    timestamp = "2026-08-04"
  }
}

output "test_output" {
  value = "storage-profile-test-39481"
}