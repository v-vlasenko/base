version = "v1"

policy "limit_resources_per_run" {
  enabled           = true
  enforcement_level = "soft-mandatory"
}

policy "forbid_unreviewed_blast_radius" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "recommend_small_changes" {
  enabled           = true
  enforcement_level = "advisory"
}
