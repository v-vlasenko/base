package terraform

import data.qa_helpers

deny[reason] {
    qa_helpers.never
    reason := "qa37302 helper never fires"
}
