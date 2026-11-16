package terraform
import data.qa39791_ctag

deny[reason] {
    not qa39791_ctag.ok(true)
    reason := "ctag_common_missing"
}
