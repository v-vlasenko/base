terraform {
  source = "."
}

dependency "foundation" {
  config_path = "../foundation"
  mock_outputs = {
    name_prefix = "mock-prefix"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "refresh"]
}

inputs = {
  name_prefix = dependency.foundation.outputs.name_prefix
}
