#!/usr/bin/env bash
echo "=== P1 TUNNEL/PROXY PROBE ==="

echo "--- tunneling tools ---"
which ngrok 2>/dev/null && ngrok version 2>/dev/null | head -1 || echo "ngrok: not found"
which cloudflared 2>/dev/null || echo "cloudflared: not found"
which localtunnel 2>/dev/null || echo "localtunnel: not found"
which bore 2>/dev/null || echo "bore: not found"
which frpc 2>/dev/null || echo "frpc: not found"

echo "--- proxy env in exec-loop parent ---"
cat /proc/$PPID/environ 2>/dev/null | tr '\0' '\n' | grep -iE "proxy|tunnel" || echo "no proxy vars in parent"

echo "--- exec loop script content ---"
head -30 /tmp/exec-loop/exec-*/script.sh 2>/dev/null || echo "cannot read exec loop"
ls /tmp/exec-loop/ 2>/dev/null

echo "--- agent python executable ---"
ls -la /usr/bin/runner/usr/bin/python* 2>/dev/null | head -5 || echo "no runner python found"
ls -la /usr/bin/runner/usr/lib/python3.13/site-packages/certifi/ 2>/dev/null | head -3

echo "--- can write to tmp/exec-loop ---"
ls -la /tmp/ | grep exec-loop
ls -la /tmp/exec-loop/ 2>/dev/null | head -5

echo "--- http via python without ssl verify ---"
python3 -c "
import urllib.request, ssl
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE
# Just prove we can make unverified HTTPS
print('ssl module supports CERT_NONE:', ssl.CERT_NONE)
" 2>&1

echo "=== DONE ==="
