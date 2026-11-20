package terraform

import input.tfplan as tfplan

created := [r | r := tfplan.resource_changes[_]; r.change.actions[_] == "create"]

deny[msg] {
    count(created) > 20
    msg := sprintf("This run creates %d resources. Runs above 20 resources must be split.", [count(created)])
}
