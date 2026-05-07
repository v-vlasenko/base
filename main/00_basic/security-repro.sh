#!/usr/bin/env bash
echo "=== P1 PRE-INIT PROBE ==="
echo "TIME=$(date +%H:%M:%S.%3N)"

echo "--- certifi ---"
CERTIFI_PATH=$(python3 -c "import certifi; print(certifi.where())" 2>/dev/null || echo "")
echo "certifi path: $CERTIFI_PATH"
if [ -n "$CERTIFI_PATH" ] && [ -f "$CERTIFI_PATH" ] && [ -w "$CERTIFI_PATH" ]; then
  echo "certifi bundle: WRITABLE"
else
  echo "certifi bundle: NOT WRITABLE"
fi

echo "--- cert gen ---"
openssl req -x509 -newkey rsa:2048 -keyout /tmp/p1_key.pem -out /tmp/p1_cert.pem -days 1 -nodes \
  -subj "/CN=127.0.0.1.nip.io" 2>/dev/null && echo "cert gen: OK" || echo "cert gen: FAILED"

echo "--- port 443 bind ---"
python3 -c "import socket; s=socket.socket(); s.bind(('',443)); print('port 443: bindable'); s.close()" 2>/dev/null || echo "port 443: cannot bind"

echo "--- working dir ---"
pwd
ls -la 2>/dev/null | head -10

echo "--- nip.io DNS ---"
python3 -c "import socket; r=socket.gethostbyname('127.0.0.1.nip.io'); print('127.0.0.1.nip.io resolves to:', r)" 2>/dev/null || echo "nip.io: DNS failed"

echo "--- providers dir ---"
ls /opt/providers 2>/dev/null | head -5 || echo "empty or no access"

echo "=== PROBE DONE ==="
