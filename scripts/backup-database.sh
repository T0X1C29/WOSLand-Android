#!/data/data/com.termux/files/usr/bin/sh
set -eu
APP=/root/python-wosland
OUT=${1:-"$HOME/wosland-db-backup-$(date +%Y%m%d-%H%M%S)"}
mkdir -p "$OUT"
"$APP/.venv313/bin/python" - "$APP" "$OUT" <<'PY'
import glob, os, sqlite3, sys
app, out = sys.argv[1:]
for src in glob.glob(os.path.join(app, "db", "*.sqlite")):
    dst = os.path.join(out, os.path.basename(src))
    s = sqlite3.connect(src); d = sqlite3.connect(dst)
    s.backup(d)
    if d.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
        raise SystemExit(f"integrity check failed: {src}")
    d.close(); s.close()
print(out)
PY

