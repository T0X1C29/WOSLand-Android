#!/data/data/com.termux/files/usr/bin/sh
set -eu

# Termux-side supervisor. The application and Python interpreter stay inside
# Debian proot; only this watchdog and its log live in Termux.
CONTAINER=${WOSLAND_CONTAINER:-wosland-test}
APP=${WOSLAND_APP_DIR:-/root/python-wosland}
PYTHON=${WOSLAND_PYTHON:-$APP/.venv313/bin/python}
START_CMD=${WOSLAND_START_CMD:-"$PYTHON main.py --no-venv"}
STATE=${WOSLAND_STATE_DIR:-$HOME/.local/var/wosland}
LOG="$STATE/watchdog.log"
LOCK="$STATE/watchdog.lock"
PIDFILE="$LOCK/pid"

mkdir -p "$STATE"
if [ -e "$LOCK" ]; then
  oldpid=$(cat "$PIDFILE" 2>/dev/null || true)
  if [ -n "$oldpid" ] && kill -0 "$oldpid" 2>/dev/null; then
    echo 'WOSLand watchdog already appears to be running.' >&2
    exit 0
  fi
  rm -rf "$LOCK"
fi
mkdir "$LOCK"
printf '%s\n' "$$" > "$PIDFILE"
cleanup() { rm -rf "$LOCK"; }
trap cleanup EXIT INT TERM

proot-distro login "$CONTAINER" -- sh -c "test -d '$APP' && test -x '$PYTHON'" \
  || { echo "Debian app or Python not found: $CONTAINER:$APP" >&2; exit 1; }

[ -e "$STATE/stop" ] && exit 0
[ -f "$LOG" ] && [ "$(wc -c < "$LOG")" -gt 5242880 ] && mv "$LOG" "$LOG.1"
while :; do
  date -Iseconds >> "$LOG"
  [ -e "$STATE/stop" ] && break
  proot-distro login "$CONTAINER" -- sh -c "cd '$APP' && MALLOC_ARENA_MAX=2 MALLOC_TRIM_THRESHOLD_=131072 exec $START_CMD" >> "$LOG" 2>&1 || true
  [ -e "$STATE/stop" ] && break
  sleep "${WOSLAND_RESTART_DELAY:-15}"
done

