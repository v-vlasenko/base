package terraform

# Compute-heavy, always-passing policy. Forces OPA to scan N*N pairs so a single
# eval runs for tens of seconds, giving a wide window to cancel mid-evaluation.
r := numbers.range(1, 6000)

burn[x] {
    some i
    r[i]
    some j
    r[j]
    x := r[i] * r[j]
    x == -1
}

deny[reason] {
    count(burn) > 0
    reason := "unreachable-slow3"
}
