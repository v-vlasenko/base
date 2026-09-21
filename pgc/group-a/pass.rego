package terraform

# PR impact analysis: previously advisory-pass, now deny everything
deny[reason] {
  reason := "pr1: advisory policy now fails for every workspace"
}
