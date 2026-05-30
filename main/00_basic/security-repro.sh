#!/bin/bash
echo "=== N1 REPRO: tfvars discovery ==="
echo "PWD: $(pwd)"
echo "whoami: $(whoami)"
echo "hostname: $(hostname)"
echo "--- /tmp contents ---"
ls -la /tmp/ 2>/dev/null || echo "no /tmp"
echo "--- /var/lib/scalr-agent contents (first 2 levels) ---"
find /var/lib/scalr-agent -maxdepth 2 2>/dev/null | head -30 || echo "no scalr-agent dir"
echo "--- find *.tfvars on filesystem (first 30) ---"
find / -maxdepth 6 \( -name "*.tfvars" -o -name "*.tfvars.json" \) 2>/dev/null | head -30
echo "--- SCALR env vars (keys only) ---"
env | grep -i scalr | sed "s/=.*/=REDACTED/"
echo "=== N1 REPRO END ==="

