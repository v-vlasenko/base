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

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnets = ["10.0.0.0/24"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "refresh"]
}

inputs = {
  name_prefix = dependency.foundation.outputs.name_prefix
  subnets = dependency.network.outputs.subnets
}
