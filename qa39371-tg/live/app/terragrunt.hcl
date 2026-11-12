include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    prefix = "mock-network"
  }
}

dependency "shared" {
  config_path = "../../shared"

  mock_outputs = {
    log_group_name = "mock-shared"
  }
}

inputs = {
  prefix           = dependency.network.outputs.prefix
  shared_log_group = dependency.shared.outputs.log_group_name
}
