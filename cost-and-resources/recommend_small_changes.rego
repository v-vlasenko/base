package terraform

import input.tfplan as tfplan

created := [r | r := tfplan.resource_changes[_]; r.change.actions[_] == "create"]

deny[msg] {
    count(created) > 2
    msg := sprintf("Consider splitting this change: %d resources are created in one run.", [count(created)])
}
