package terraform

import input.tfrun as tfrun

deny[msg] {
    tfrun.is_destroy
    not contains(tfrun.workspace.name, "sandbox")
    msg := sprintf("Destroy runs are blocked for workspace %q. Only sandbox workspaces can be destroyed without a decommission request.", [tfrun.workspace.name])
}
