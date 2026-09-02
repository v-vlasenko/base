terraform {
  source = "."
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnets = ["10.0.0.0/24"]
  }
}

inputs = {
  subnets = dependency.network.outputs.subnets
}
