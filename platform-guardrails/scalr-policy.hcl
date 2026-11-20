version = "v1"

policy "block_destroy_runs" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "restrict_auto_apply_in_production" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "workspace_naming_convention" {
  enabled           = true
  enforcement_level = "advisory"
}
