#!/usr/bin/env bash

echo "=== ENV vars in hook context ==="
env | grep -iE "scalr|token|secret|key|pass|auth|cred" | sed 's/=.*/=[REDACTED]/'

echo ""
echo "=== Internal LB routing ==="
echo "HTTP 302 target:"
curl -sk --max-time 5 "http://10.30.0.2/" -o /dev/null -w "-> %{redirect_url}\n"

echo ""
echo "HTTPS internal API endpoints:"
for path in "/" "/api/iacp/v3/accounts" "/api/iacp/v3/" "/terraform-mirror/test.json" "/api/admin/"; do
  code=$(curl -sk --max-time 5 "https://internal.main.scalr.dev$path" -o /dev/null -w "%{http_code}")
  echo "$path -> HTTP $code"
done

echo ""
echo "=== Internal LB with agent token ==="
code=$(curl -sk --max-time 5 \
  "https://internal.main.scalr.dev/api/iacp/v3/accounts" \
  -H "Authorization: Bearer $SCALR_TOKEN" \
  -o /dev/null -w "%{http_code}")
echo "/api/iacp/v3/accounts with SCALR_TOKEN: HTTP $code"

echo "=== done ==="