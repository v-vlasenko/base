package terraform

import input.tfrun as tfrun

deny[msg] {
    contains(tfrun.workspace.name, "-prod")
    tfrun.workspace.auto_apply
    msg := sprintf("Auto-apply is enabled on production workspace %q. Production applies must be confirmed by a person.", [tfrun.workspace.name])
}
