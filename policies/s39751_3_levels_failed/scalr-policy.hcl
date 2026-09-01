version = "v1"

policy "adv" {
  enabled           = true
  enforcement_level = "advisory"
}

policy "soft" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "hard" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}
