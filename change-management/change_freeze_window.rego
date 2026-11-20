package terraform

import input.tfrun as tfrun

is_prod {
    contains(tfrun.workspace.name, "-prod")
}

deny[msg] {
    is_prod
    msg := sprintf("Change freeze is in effect until 2026-12-01 08:00 UTC. Production workspace %q needs a Change Advisory Board exemption to deploy.", [tfrun.workspace.name])
}

deny[msg] {
    is_prod
    contains(tfrun.workspace.name, "network-foundation")
    msg := "Shared network foundation is a tier-0 system: during the freeze every change also needs a sign-off from the on-call network engineer, a tested rollback plan attached to the change ticket and a maintenance notice sent to all dependent teams at least 24 hours before the deployment window opens."
}

deny[msg] {
    is_prod
    contains(tfrun.workspace.name, "network-foundation")
    msg := "Region eu-central-1 is under an additional regional freeze (INC-20871) until further notice."
}
