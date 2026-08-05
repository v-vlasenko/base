terraform {
  source = "."
}

dependency "unit_a" {
  config_path = "../unit-a"
}