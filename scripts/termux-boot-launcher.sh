#!/data/data/com.termux/files/usr/bin/sh
set -eu
sleep "${WOSLAND_BOOT_DELAY:-30}"
exec "$HOME/.local/bin/wosland-watchdog"

