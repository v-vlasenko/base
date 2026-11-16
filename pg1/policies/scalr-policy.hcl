version = "v1"

policy "uses_helper_pass" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "uses_helper_deny" {
  enabled           = true
  enforcement_level = "advisory"
}

policy "../../shared/tags" {
  enabled           = true
  enforcement_level = "advisory"
}

policy "disabled_one" {
  enabled           = false
  enforcement_level = "hard-mandatory"
}

policy "unit_a_only" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}
