#!/data/data/com.termux/files/usr/bin/sh
set -eu
APP=${WOSLAND_APP_DIR:-/root/python-wosland}
PYTHON=${WOSLAND_PYTHON:-$APP/.venv313/bin/python}
test -x "$PYTHON" || { echo 'Python virtual environment not found.' >&2; exit 1; }
"$PYTHON" - <<'PY'
import importlib
mods = ('aiohttp','discord','requests','onnxruntime','rapidocr','numpy','cv2','PIL','matplotlib')
for mod in mods:
    importlib.import_module(mod)
    print(f'OK {mod}')
print('Native dependency imports passed. Run a real OCR image test separately.')
PY

