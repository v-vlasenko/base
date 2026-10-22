package terraform

import input.tfplan as tfplan

deny[reason] {
    v := tfplan.variables[name].value
    reason := sprintf("qa40876 %s=%v", [name, v])
}
