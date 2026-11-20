package terraform

import input.tfrun as tfrun

deny[msg] {
    contains(tfrun.workspace.name, "-prod")
    not regex.match(`CHG-[0-9]+`, object.get(tfrun, "message", ""))
    msg := "Run message must reference an approved change ticket, for example \"CHG-10482: rotate database credentials\"."
}
