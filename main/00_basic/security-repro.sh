#!/usr/bin/env bash
echo "=== P1 AGENT PYTHON PROBE ==="
echo "TIME=$(date +%H:%M:%S.%3N)"

RUNNER_PY=$(ls /usr/bin/runner/usr/bin/python3* 2>/dev/null | tail -1)
echo "Runner Python: $RUNNER_PY"

if [ -n "$RUNNER_PY" ]; then
  echo "--- runner python PATH and unzip ---"
  "$RUNNER_PY" -c "
import os, shutil, sys
print('sys.version:', sys.version.split()[0])
print('os PATH:', os.environ.get('PATH', '(not set)'))
unzip = shutil.which('unzip')
print('shutil.which(unzip):', unzip)
" 2>&1

  echo "--- runner python zipfile extractall test ---"
  "$RUNNER_PY" -c "
import zipfile, tempfile, os, pathlib
# Test whether extractall blocks traversal or allows it
with tempfile.TemporaryDirectory() as tmpdir:
    # Create test zip with traversal entry
    import io, struct
    # Use zipfile module to create the zip
    zb = io.BytesIO()
    with zipfile.ZipFile(zb, 'w') as zf:
        zf.writestr('safe_file.txt', 'safe')
        # Manually add traversal entry
    # Check if extractall would traverse
    print('zipfile.extractall traversal:', 'check below')
    
# Actually test with our evil zip if it exists
evil_zip = '/tmp/evil_probe.zip'
try:
    with zipfile.ZipFile(evil_zip, 'r') as z:
        members = z.namelist()
        print('zip members:', members)
except FileNotFoundError:
    print('no evil zip at /tmp/evil_probe.zip')
" 2>&1

  echo "--- where is the agent installed? ---"
  find /usr/bin/runner/usr/lib/python3*/site-packages/ -name "tacoagent*" -maxdepth 2 2>/dev/null | head -5
  "$RUNNER_PY" -c "import tacoagent; print(tacoagent.__file__)" 2>&1 | head -3
fi

echo "--- hook env PATH and unzip ---"
echo "PATH=$PATH"
which unzip 2>/dev/null
unzip --version 2>&1 | head -2

echo "=== DONE ==="
