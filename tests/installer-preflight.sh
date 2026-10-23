#!/usr/bin/env sh
set -eu

ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
fail() { echo "FAIL: $*" >&2; exit 1; }
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp/app" "$tmp/wheels"
printf '%s\n' 'example-package==0.0.0' > "$tmp/app/requirements.txt"
touch "$tmp/wheels/.placeholder"

if WOSLAND_APP_DIR="$tmp/app" WOSLAND_WHEELHOUSE="$tmp/wheels" WOSLAND_PYTHON=python3 \
  sh "$ROOT/scripts/install-offline.sh" >/dev/null 2>&1; then
  fail 'wrong Python version was accepted'
fi
test ! -e "$tmp/app/.venv313" || fail 'failed preflight created a virtual environment'

if WOSLAND_APP_DIR="$tmp/app" WOSLAND_WHEELHOUSE="$tmp/missing" WOSLAND_PYTHON=python3 \
  sh "$ROOT/scripts/install-offline.sh" >/dev/null 2>&1; then
  fail 'missing wheelhouse was accepted'
fi
echo 'PASS: installer preflight rejection tests'
