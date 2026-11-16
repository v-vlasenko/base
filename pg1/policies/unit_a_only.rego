package terraform

deny[reason] {
    rc := input.tfplan.resource_changes[_]
    rc.address == "terraform_data.unit_a"
    reason := "qa37302 deny only for unit-a"
}
