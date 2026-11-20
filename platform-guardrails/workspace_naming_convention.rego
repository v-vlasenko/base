package terraform

import input.tfrun as tfrun

deny[msg] {
    not regex.match(`^[a-z0-9-]+-(prod|staging|dev)(-[a-z0-9-]+)?$`, tfrun.workspace.name)
    msg := sprintf("Workspace name %q does not follow <service>-<prod|staging|dev>[-<region>].", [tfrun.workspace.name])
}
