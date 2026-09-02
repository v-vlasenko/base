terraform {
  source = "."
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnets = ["10.0.0.0/24"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "refresh"]
}

inputs = {
  subnets = dependency.network.outputs.subnets
}
