package terraform

import input.tfplan as tfplan

has_managed_by(tags) {
    tags.ManagedBy
}

deny[reason] {
    r := tfplan.resource_changes[_]
    startswith(r.type, "aws_")
    r.change.actions[_] != "delete"
    tags := object.get(r.change.after, "tags_all", null)
    not has_managed_by(tags)
    reason := sprintf("%s is missing the ManagedBy tag", [r.address])
}
