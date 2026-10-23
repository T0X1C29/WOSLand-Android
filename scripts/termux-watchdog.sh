#!/data/data/com.termux/files/usr/bin/sh
set -eu
APP=/root/python-wosland
LOG="$APP/logs/watchdog.log"
mkdir -p "$APP/logs"
while :; do
  date -Iseconds >> "$LOG"
  cd "$APP"
  MALLOC_ARENA_MAX=2 MALLOC_TRIM_THRESHOLD_=131072 .venv/bin/python main.py --no-venv >> "$LOG" 2>&1 || true
  sleep 15
done

