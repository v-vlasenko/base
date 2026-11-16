package terraform

import data.qa_helpers

deny[reason] {
    qa_helpers.never
    reason := "qa37302 helper never fires"
}
# s13 1794854705
# s13 restore 1794854906
