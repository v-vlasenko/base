include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "net" {
  config_path = "../net"

  mock_outputs = {
    prefix = "mock-network"
  }
}

inputs = {
  prefix           = dependency.net.outputs.prefix
  shared_log_group = "stack"
}
