version = "v1"

policy "hard" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "soft" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "advisory" {
  enabled           = true
  enforcement_level = "advisory"
}
