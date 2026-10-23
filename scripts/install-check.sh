#!/data/data/com.termux/files/usr/bin/sh
set -eu
APP=${WOSLAND_APP_DIR:-/root/python-wosland}
PYTHON=${WOSLAND_PYTHON:-$APP/.venv313/bin/python}
test -f /etc/debian_version || { echo 'Run this inside Debian, not directly in Termux.' >&2; exit 1; }
test "$(uname -s)" = Linux || { echo 'Linux is required.' >&2; exit 1; }
test -x "$PYTHON" || { echo 'Python virtual environment not found.' >&2; exit 1; }
"$PYTHON" - <<'PY'
import importlib
import platform, sys
if sys.version_info[:2] != (3, 13): raise SystemExit('Expected CPython 3.13.')
if platform.machine() not in ('aarch64', 'arm64'): raise SystemExit('Expected Linux ARM64.')
mods = ('aiohttp','discord','requests','onnxruntime','rapidocr','numpy','cv2','PIL','matplotlib')
for mod in mods:
    importlib.import_module(mod)
    print(f'OK {mod}')
print('Native dependency imports passed. Run a real OCR image test separately.')
PY

