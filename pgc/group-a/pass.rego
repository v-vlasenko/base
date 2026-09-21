package terraform
import input.tfrun as tfrun

bool_value = false

deny[reason] {
    check := bool_value
    check == true
    reason := "This policy should be passed in any case."
}