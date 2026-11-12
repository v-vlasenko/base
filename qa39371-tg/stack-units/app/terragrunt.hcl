include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "net" {
  config_path = "../net"

  mock_outputs = {
    prefix = "mock-network"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  prefix           = dependency.net.outputs.prefix
  shared_log_group = "stack"
}
