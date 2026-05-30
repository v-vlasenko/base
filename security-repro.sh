#!/bin/bash
echo "=== N1 REPRO: tfvars discovery ==="
echo "PWD: $(pwd)"
echo "whoami: $(whoami)"
echo "hostname: $(hostname)"
echo "--- /tmp contents ---"
ls -la /tmp/ 2>/dev/null || echo "no /tmp"
echo "--- find *.tfvars on filesystem (first 20) ---"
find / -name "*.tfvars" -o -name "*.tfvars.json" 2>/dev/null | head -20
echo "--- SCALR env vars (keys only) ---"
env | grep -i scalr | sed "s/=.*/=REDACTED/"
echo "=== N1 REPRO END ==="

