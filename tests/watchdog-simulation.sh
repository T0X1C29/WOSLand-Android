#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail() { echo "FAIL: $*" >&2; exit 1; }
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp/bin" "$tmp/state" "$tmp/state/watchdog.lock"
mkdir -p "$tmp/app/.venv313"
touch "$tmp/app/.venv313/bin-python"
chmod +x "$tmp/app/.venv313/bin-python"
printf '999999\n' > "$tmp/state/watchdog.lock/pid"
cat > "$tmp/bin/proot-distro" <<'EOF'
#!/usr/bin/env sh
shift 2
shift
exec "$@"
EOF
chmod +x "$tmp/bin/proot-distro"
touch "$tmp/state/stop"
WOSLAND_STATE_DIR="$tmp/state" WOSLAND_STOP_MARKER="$tmp/state/stop" \
  WOSLAND_APP_DIR="$tmp/app" WOSLAND_PYTHON="$tmp/app/.venv313/bin-python" \
  PATH="$tmp/bin:/usr/bin:/bin" sh "$ROOT/scripts/termux-watchdog.sh" >/dev/null 2>&1 \
  || fail 'watchdog did not exit cleanly with stop marker'
test ! -e "$tmp/state/watchdog.lock" || fail 'stale lock was not recovered'
echo 'PASS: watchdog stale-lock and stop-marker simulation'
