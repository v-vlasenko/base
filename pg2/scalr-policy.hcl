version = "v1"

policy "pg2_pass" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "pg2_new" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}
