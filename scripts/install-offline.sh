#!/data/data/com.termux/files/usr/bin/sh
set -eu

APP=${WOSLAND_APP_DIR:-/root/python-wosland}
WHEELHOUSE=${1:-${WOSLAND_WHEELHOUSE:-/root/wheelhouse}}
PYTHON=${WOSLAND_PYTHON:-python3.13}

command -v "$PYTHON" >/dev/null 2>&1 || { echo "Missing $PYTHON; choose a compatible Python first." >&2; exit 1; }
test -f "$APP/requirements.txt" || { echo "Missing $APP/requirements.txt" >&2; exit 1; }
test -d "$WHEELHOUSE" || { echo "Missing wheelhouse: $WHEELHOUSE" >&2; exit 1; }

"$PYTHON" - <<'PY'
import platform, sys
print(f'Python: {platform.python_version()} ABI: cp{sys.version_info.major}{sys.version_info.minor}')
print(f'Machine: {platform.machine()}')
if sys.version_info[:2] != (3, 13):
    raise SystemExit('This verified wheelhouse targets CPython 3.13; stop instead of guessing.')
if platform.machine() not in ('aarch64', 'arm64'):
    raise SystemExit('This verified wheelhouse targets Linux ARM64; stop instead of guessing.')
PY

mkdir -p "$APP/.venv313"
if [ ! -x "$APP/.venv313/bin/python" ]; then
  "$PYTHON" -m venv "$APP/.venv313"
fi
"$APP/.venv313/bin/python" -m pip install --no-index --find-links="$WHEELHOUSE" -r "$APP/requirements.txt"
echo 'Offline dependency installation completed.'

