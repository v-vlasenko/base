terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "security_test_mirror" {
  triggers = {
    run_id = "c4-mirror-repro"
  }
}
