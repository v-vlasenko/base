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
  name_prefix = dependency.foundation.outputs.name_prefix
}
