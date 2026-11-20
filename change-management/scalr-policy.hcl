version = "v1"

policy "change_freeze_window" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "require_change_ticket" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "workspace_description_required" {
  enabled           = true
  enforcement_level = "advisory"
}

policy "allowed_run_sources" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}
