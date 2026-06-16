package terraform

import input.tfrun as tfrun

deny[reason] {
    vars := {v.key: v.value | v := tfrun.shell_variables[_]}
    not vars["MY_FLAG"] == "policy_test_val"
    reason := sprintf("MY_FLAG snapshot value mismatch, got: %v", [vars["MY_FLAG"]])
}

