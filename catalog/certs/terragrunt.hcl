terraform {
  source = "."
}

dependency "foundation" {
  config_path = "../foundation"
  mock_outputs = {
    name_prefix = "mock-prefix"
  }
}

inputs = {
  common_name = dependency.foundation.outputs.name_prefix
}
