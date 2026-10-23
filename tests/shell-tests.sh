#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail() { echo "FAIL: $*" >&2; exit 1; }

for script in "$ROOT"/scripts/*.sh; do
  sh -n "$script" || fail "shell syntax: $script"
done
grep -q 'proot-distro login' "$ROOT/scripts/termux-watchdog.sh" || fail 'watchdog must enter Debian'
grep -q 'WOSLAND_CONTAINER' "$ROOT/scripts/termux-watchdog.sh" || fail 'container must be configurable'
grep -q '/etc/debian_version' "$ROOT/scripts/install-offline.sh" || fail 'offline installer must require Debian'
grep -q '/etc/debian_version' "$ROOT/scripts/install-check.sh" || fail 'import checker must require Debian'
grep -q 'su -c' "$ROOT/scripts/compatibility-check.sh" && fail 'checker must not invoke su automatically'
grep -q 'WOSLAND_APP_DIR' "$ROOT/scripts/install-offline.sh" || fail 'app path must be configurable'
grep -q 'on_term' "$ROOT/scripts/termux-watchdog.sh" || fail 'watchdog must exit on termination'
grep -q 'WOSLAND_STOP_MARKER' "$ROOT/scripts/termux-watchdog.sh" || fail 'stop marker must be configurable'
echo 'PASS: shell syntax and safety checks'
