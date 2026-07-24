#!/bin/bash
# documented interface: propagates to subsequent hooks/operations via env dump
echo "FOO=bar" >> "$SCALR_AGENT_ENV"
export PLAIN_EXPORT=only_in_child
echo "hook1: wrote FOO=bar to SCALR_AGENT_ENV; PLAIN_EXPORT set in-child only"
