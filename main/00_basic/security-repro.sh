#!/usr/bin/env bash
echo "=== P1 RUNNER PYTHON PROBE ==="
echo "TIME=$(date +%H:%M:%S.%3N)"

echo "--- list /usr/bin/runner/usr/bin/ ---"
ls -la /usr/bin/runner/usr/bin/ 2>/dev/null | head -20 || echo "not found"

echo "--- find python in runner ---"
find /usr/bin/runner/usr/bin/ -name "python*" -not -name "*.h" -not -name "*config*" 2>/dev/null

RUNNER_PY=$(find /usr/bin/runner/usr/bin/ -name "python3*" -not -name "*.h" -not -name "*config*" 2>/dev/null | grep -v config | head -1)
echo "Runner Python: $RUNNER_PY"

if [ -n "$RUNNER_PY" ]; then
  echo "--- runner python shutil.which(unzip) ---"
  "$RUNNER_PY" -c "
import shutil, os, sys
print('version:', sys.version.split()[0])
print('PATH:', os.environ.get('PATH', '(none)'))
unzip = shutil.which('unzip')
print('shutil.which(unzip):', unzip)
import subprocess
res = subprocess.run(['which', 'unzip'], capture_output=True)
print('subprocess which unzip:', res.stdout.decode().strip())
" 2>&1

  echo "--- test zipfile traversal with runner python ---"
  "$RUNNER_PY" -c "
import zipfile, tempfile, pathlib
with tempfile.TemporaryDirectory() as tmpdir:
    dest = pathlib.Path(tmpdir) / 'unzip_dir'
    dest.mkdir()
    with zipfile.ZipFile('/tmp/evil_probe.zip', 'r') as z:
        z.extractall(dest)
    # List what was extracted
    for f in sorted(pathlib.Path(tmpdir).rglob('*')):
        print(f.relative_to(tmpdir))
" 2>&1 || echo "no evil_probe.zip available"
fi

echo "=== DONE ==="
