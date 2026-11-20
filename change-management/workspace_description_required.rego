package terraform

import input.tfrun as tfrun

has_description {
    count(tfrun.workspace.description) > 0
}

deny[msg] {
    not has_description
    msg := sprintf("Workspace %q has no description. Add the owning team and the on-call contact.", [tfrun.workspace.name])
}
