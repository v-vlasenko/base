#!/bin/bash

chmod +x nested/*.sh
set -e

# Generate timestamp for filename
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$SCALR_HOOK_DIR/env_vars_$TIMESTAMP.txt"

# Store environment variables in the file
printenv | tee -a "$FILENAME"

# Export the filename as an environment variable
export TF_VAR_env_vars_filename="$FILENAME"
echo "Environment variables saved to: $FILENAME"
echo "Environment variables file name is $TF_VAR_env_vars_filename"

echo "Calling $SCALR_HOOK_DIR/nested/install_jq_and_parse_response.sh..."
"$SCALR_HOOK_DIR/nested/install_jq_and_parse_response.sh"
