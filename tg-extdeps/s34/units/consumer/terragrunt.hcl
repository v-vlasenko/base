dependency "ext" {
  config_path  = "${get_terragrunt_dir()}/../../external/producer"
  mock_outputs = {
    pet = "mock-pet"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate"]
}
inputs = {
  upstream = dependency.ext.outputs.pet
}
