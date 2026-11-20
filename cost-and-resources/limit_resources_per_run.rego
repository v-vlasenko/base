package terraform

import input.tfplan as tfplan

created := [r | r := tfplan.resource_changes[_]; r.change.actions[_] == "create"]

deny[msg] {
    count(created) > 5
    msg := sprintf("This run creates %d resources, the limit without a review is 5.", [count(created)])
}
