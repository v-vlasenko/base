package terraform

# PR impact analysis: previously advisory-pass, now deny everything
deny[reason] {
  reason := "pr1: advisory policy now fails for every workspace"
}
# marker 2026-09-21T14:38:27Z item1-multi-env
