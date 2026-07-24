#!/bin/bash
echo "TF_VAR_input=from_hook_env" >> "$SCALR_AGENT_ENV"
echo "hook1: wrote TF_VAR_input=from_hook_env to SCALR_AGENT_ENV"
