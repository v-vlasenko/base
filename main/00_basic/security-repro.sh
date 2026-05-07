#!/usr/bin/env bash
echo "=== P1 PARENT ENV PROBE ==="
echo "PID=$$ PPID=$PPID"

echo "--- parent environ (REQUESTS_CA_BUNDLE, SSL_CERT_FILE) ---"
if [ -r "/proc/$PPID/environ" ]; then
  cat /proc/$PPID/environ | tr '\0' '\n' | grep -E "REQUESTS_CA_BUNDLE|SSL_CERT_FILE|CURL_CA_BUNDLE|CERTIFI" || echo "not found in parent env"
else
  echo "/proc/$PPID/environ not readable"
fi

echo "--- grandparent environ ---"
GPID=$(cat /proc/$PPID/status 2>/dev/null | awk '/^PPid:/{print $2}')
echo "GPID=$GPID"
if [ -n "$GPID" ] && [ -r "/proc/$GPID/environ" ]; then
  cat /proc/$GPID/environ | tr '\0' '\n' | grep -E "REQUESTS_CA_BUNDLE|SSL_CERT_FILE" || echo "not found in gp env"
else
  echo "/proc/$GPID/environ not readable"
fi

echo "--- find agent python ---"
ls -la /proc/$PPID/exe 2>/dev/null || echo "no exe link"
cat /proc/$PPID/cmdline 2>/dev/null | tr '\0' ' ' | head -c 200; echo

echo "--- find certifi in agent venv ---"
find /opt -name "cacert.pem" 2>/dev/null | head -5
find /usr -name "cacert.pem" 2>/dev/null | head -5

echo "--- writable certifi candidates ---"
find / -name "cacert.pem" 2>/dev/null | while read f; do
  if [ -w "$f" ]; then echo "WRITABLE: $f"; else echo "readonly: $f"; fi
done

echo "=== DONE ==="
