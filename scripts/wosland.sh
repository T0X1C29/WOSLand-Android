#!/data/data/com.termux/files/usr/bin/sh
set -eu

APP=${WOSLAND_APP_DIR:-/root/python-wosland}
STATE=${WOSLAND_STATE_DIR:-$HOME/.local/var/wosland}
STOP=${WOSLAND_STOP_MARKER:-$HOME/.wosland-python.stop}
WATCHDOG=${WOSLAND_WATCHDOG:-$HOME/.local/bin/wosland-watchdog}
LOG="$STATE/watchdog.log"

usage() {
  cat <<'EOF'
Usage: wosland.sh <command>
Commands: install start stop restart status logs check diagnostics update backup restore uninstall
Environment: WOSLAND_APP_DIR, WOSLAND_STATE_DIR, WOSLAND_STOP_MARKER, WOSLAND_WATCHDOG
EOF
}

case ${1:-} in
  install)
    test ! -e "$APP" || { echo "Refusing to overwrite existing app: $APP" >&2; exit 1; }
    sh "$(dirname "$0")/fetch-upstream.sh"
    sh "$(dirname "$0")/install-offline.sh"
    ;;
  start)
    rm -f "$STOP"
    exec "$WATCHDOG"
    ;;
  stop)
    mkdir -p "$(dirname "$STOP")"
    : > "$STOP"
    echo "Stop marker set: $STOP"
    ;;
  restart)
    "$0" stop
    sleep "${WOSLAND_RESTART_WAIT:-2}"
    exec "$0" start
    ;;
  status)
    if [ -f "$STATE/watchdog.lock/pid" ] && kill -0 "$(cat "$STATE/watchdog.lock/pid")" 2>/dev/null; then
      echo "watchdog: running ($(cat "$STATE/watchdog.lock/pid"))"
    else
      echo 'watchdog: not running'
    fi
    [ -e "$STOP" ] && echo "stop-marker: present ($STOP)" || echo 'stop-marker: absent'
    ;;
  logs)
    test -f "$LOG" || { echo "No log yet: $LOG"; exit 0; }
    tail -n "${WOSLAND_LOG_LINES:-100}" "$LOG"
    ;;
  check)
    exec sh "$(dirname "$0")/install-check.sh"
    ;;
  diagnostics)
    exec sh "$(dirname "$0")/health-check.sh"
    ;;
  update)
    echo 'Updates are deliberately manual: review the upstream commit, back up, then use fetch-upstream.sh with a new app path.'
    exit 2
    ;;
  backup)
    exec sh "$(dirname "$0")/backup-database.sh" "${2:-}"
    ;;
  restore)
    echo 'Restore is intentionally manual; stop the watchdog, verify an archive, and restore only to WOSLAND_APP_DIR.' >&2
    exit 2
    ;;
  uninstall)
    echo 'Refusing automatic uninstall. Remove only the documented WOSLAND paths after preserving a verified backup.' >&2
    exit 2
    ;;
  *) usage >&2; exit 2 ;;
esac
