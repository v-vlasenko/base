#!/bin/bash
echo "=== GIT ARG INJECTION DEMO ==="
echo "SCALR_WORKSPACE_ID: $SCALR_WORKSPACE_ID"
echo ""
echo "--- git log (what was actually fetched) ---"
git -C "$SCALR_WORK_DIR" log --oneline -5 2>/dev/null || git log --oneline -5 2>/dev/null || echo "git log failed"
echo ""
echo "--- git branch -a (all refs available) ---"
git -C "$SCALR_WORK_DIR" branch -a 2>/dev/null || git branch -a 2>/dev/null || echo "git branch failed"
echo ""
echo "--- env vars (sanitized) ---"
env | grep -E "SCALR_|GIT_|HOME|PWD" | sort
echo "==========================="

