package terraform

# Intentionally malformed rego: unterminated string -> opa eval parse error (exit != 0).
# This is a system-level evaluation failure, not a policy denial.
deny[msg] {
    msg := "unterminated
}
