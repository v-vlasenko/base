variables {
  expected_pcfg_id   = "pcfg-v0pfe99cfol6h4aej"
  expected_pcfg_name = "qa40980-pcfg1-renamed"
}

run "claims" {
  command = plan

  assert {
    condition     = startswith(data.aws_caller_identity.this.arn, "arn:aws:sts::971604682574:assumed-role/qa40980-oidc-role/")
    error_message = "unexpected caller: ${data.aws_caller_identity.this.arn}"
  }

  assert {
    condition     = local.claims.scalr_provider_configuration_id == var.expected_pcfg_id && local.claims.scalr_provider_configuration_name == var.expected_pcfg_name
    error_message = "claims: ${jsonencode(local.claims)}"
  }

  assert {
    condition     = !can(local.claims.scalr_workspace_id) && can(local.claims.scalr_test_run_id) && can(local.claims.scalr_module_id)
    error_message = "claim set: ${jsonencode(local.claims)}"
  }
}
