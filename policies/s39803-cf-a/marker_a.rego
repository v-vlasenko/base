package terraform

import data.helpers

deny[reason] {
    helpers.marker != "A"
    reason := sprintf("CONTAMINATION: group A expected marker A, got %v", [helpers.marker])
}
