version = "v1"

policy "random" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "fail" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "pass" {
  enabled           = true
  enforcement_level = "advisory"
}