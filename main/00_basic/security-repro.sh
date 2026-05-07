#!/usr/bin/env bash
set -e

echo "=== P1 ENV PROBE ==="

echo "--- identity ---"
whoami
id

echo "--- /etc/hosts writable? ---"
if [ -w /etc/hosts ]; then echo "YES /etc/hosts writable"; else echo "NO /etc/hosts not writable"; fi

echo "--- /etc/ssl/certs writable? ---"
if [ -w /etc/ssl/certs ]; then echo "YES /etc/ssl/certs writable"; else echo "NO not writable"; fi

echo "--- unzip ---"
which unzip 2>/dev/null && unzip -v 2>/dev/null | head -1 || echo "unzip: NOT FOUND"

echo "--- python ---"
python3 --version 2>&1

echo "--- openssl ---"
which openssl && openssl version || echo "openssl: not found"

echo "--- can bind port 443? ---"
python3 -c "import socket; s=socket.socket(); s.bind((\"\", 443)); print(\"port 443: bindable\"); s.close()" 2>/dev/null || echo "port 443: cannot bind (non-root)"

echo "--- can bind port 8443? ---"
python3 -c "import socket; s=socket.socket(); s.bind((\"\", 8443)); print(\"port 8443: bindable\"); s.close()" 2>/dev/null || echo "port 8443: cannot bind"

echo "--- TF env vars ---"
echo "TF_CLI_CONFIG_FILE=${TF_CLI_CONFIG_FILE}"
echo "TF_PLUGIN_CACHE_DIR=${TF_PLUGIN_CACHE_DIR}"
echo "SCALR_HOOK_DIR=${SCALR_HOOK_DIR}"
echo "HOME=${HOME}"
echo "USER=${USER}"
echo "SCALR_HOSTNAME=${SCALR_HOSTNAME}"

echo "--- interesting dirs ---"
ls /opt/scalr 2>/dev/null && echo "/opt/scalr exists" || echo "no /opt/scalr"
ls /home 2>/dev/null
ls /root 2>/dev/null && echo "/root accessible" || echo "/root: no access"

echo "--- REQUESTS_CA_BUNDLE / SSL_CERT_FILE ---"
echo "REQUESTS_CA_BUNDLE=${REQUESTS_CA_BUNDLE}"
echo "SSL_CERT_FILE=${SSL_CERT_FILE}"
echo "CURL_CA_BUNDLE=${CURL_CA_BUNDLE}"

echo "--- network: can reach registry.terraform.io? ---"
curl -sf -o /dev/null -w "registry.terraform.io HTTP %{http_code}
" "https://registry.terraform.io/.well-known/terraform.json" --max-time 5 || echo "registry.terraform.io: unreachable"

echo "=== PROBE DONE ==="

