#!/data/data/com.termux/files/usr/bin/sh
set -eu
APP=/root/python-wosland
LOG="$APP/logs/watchdog.log"
LOCK="$APP/.watchdog.lock"
STOP="$APP/.stop"
mkdir -p "$APP/logs"
if ! mkdir "$LOCK" 2>/dev/null; then
  echo 'WOSLand watchdog already appears to be running.' >&2
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT INT TERM
[ -e "$STOP" ] && exit 0
[ -f "$LOG" ] && [ "$(wc -c < "$LOG")" -gt 5242880 ] && mv "$LOG" "$LOG.1"
while :; do
  date -Iseconds >> "$LOG"
  cd "$APP"
  [ -e "$STOP" ] && break
  MALLOC_ARENA_MAX=2 MALLOC_TRIM_THRESHOLD_=131072 .venv313/bin/python main.py --no-venv >> "$LOG" 2>&1 || true
  sleep 15
done

