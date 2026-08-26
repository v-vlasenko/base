package terraform

import data.helpers

deny[reason] {
    helpers.marker != "B"
    reason := sprintf("CONTAMINATION: group B expected marker B, got %v", [helpers.marker])
}
