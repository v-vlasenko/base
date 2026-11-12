include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    prefix = "mock-network"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "shared" {
  config_path = "../../shared"

  mock_outputs = {
    log_group_name = "mock-shared"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  prefix           = dependency.network.outputs.prefix
  shared_log_group = dependency.shared.outputs.log_group_name
}
