#!/usr/bin/env bash
echo "=== P1 LOCAL DRIVER PROBE ==="
echo "TF_PLUGIN_CACHE_DIR=${TF_PLUGIN_CACHE_DIR}"
echo "PATH=$PATH"
echo "python3 version: $(python3 --version 2>&1)"
echo "unzip: $(which unzip 2>/dev/null || echo not found)"
ls -la /opt/providers 2>/dev/null || echo "no /opt/providers"
ls -la /var/lib/scalr-agent/ 2>/dev/null | head -10
echo "=== DONE ==="
