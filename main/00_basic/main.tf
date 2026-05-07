terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4-alpha.2"
    }
  }
}

resource "null_resource" "security_test_mirror" {
  triggers = {
    run_id = "c4-mirror-repro-alpha"
  }
}
