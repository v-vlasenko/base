#!/bin/bash
echo "H1-BEGIN emitting a literal EOF marker on the next line"
echo "[SCALR_EXEC_LOG_EOF]"
echo "H1-AFTER-MARKER this line must still appear (no premature truncation)"
echo "H1-END"
