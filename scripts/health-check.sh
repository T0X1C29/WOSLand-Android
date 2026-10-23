#!/data/data/com.termux/files/usr/bin/sh
set -eu
APP=/root/python-wosland
test -x "$APP/.venv313/bin/python" || { echo 'Python 3.13 venv missing' >&2; exit 1; }
test -f "$APP/bot_token.txt" || { echo 'Private token file missing' >&2; exit 1; }
test ! -e "$HOME/.wosland-python.stop" || { echo 'Intentional stop marker exists' >&2; exit 1; }
pgrep -f 'python main.py --no-venv' >/dev/null || { echo 'WOSLand process missing' >&2; exit 1; }
echo 'WOSLand watchdog/process prerequisites look healthy.'

