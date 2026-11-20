package terraform

import input.tfrun as tfrun

blocked_sources := {"auto-destroy"}

deny[msg] {
    blocked_sources[tfrun.source]
    msg := sprintf("Runs from source %q are not allowed in this environment.", [tfrun.source])
}
