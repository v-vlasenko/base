terraform {
  source = "."
}

dependency "unit_a" {
  config_path = "../unit-a"

  mock_outputs = {
    account_id = "mock-account-id"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}