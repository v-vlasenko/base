package terraform

import data.qa_helpers

deny[reason] {
    qa_helpers.always
    reason := "qa37302 deny from common function"
}
