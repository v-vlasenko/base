#!/usr/bin/env bash
echo "=== P1 ZIPSLIP TRAVERSAL CHECK ==="
echo "TIME=$(date +%H:%M:%S.%3N)"
echo "HOOK_EVENT=$HOOK_EVENT"
echo "PWD=$(pwd)"

echo "--- check /opt/providers/ for traversal marker ---"
if [ -f "/opt/providers/zipslip_CONFIRMED.txt" ]; then
  echo "ZIPSLIP CONFIRMED: /opt/providers/zipslip_CONFIRMED.txt EXISTS"
  cat /opt/providers/zipslip_CONFIRMED.txt
else
  echo "NOT FOUND: /opt/providers/zipslip_CONFIRMED.txt"
fi

echo "--- check workdir for traversal marker ---"
if [ -f "zipslip_proof.txt" ]; then
  echo "WORKDIR TRAVERSAL: zipslip_proof.txt EXISTS in workdir"
  cat zipslip_proof.txt
else
  echo "NOT FOUND: zipslip_proof.txt in workdir"
fi

echo "--- list /opt/providers/ ---"
ls -la /opt/providers/ 2>/dev/null | head -20 || echo "cannot list /opt/providers/"

echo "--- list /opt/providers-downloads/ ---"
ls -la /opt/providers-downloads/ 2>/dev/null | head -10 || echo "cannot list /opt/providers-downloads/"

echo "--- find all zipslip files ---"
find /opt/ -name "zipslip*" 2>/dev/null

echo "=== DONE ==="
