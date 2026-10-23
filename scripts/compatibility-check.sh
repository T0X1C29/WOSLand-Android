#!/data/data/com.termux/files/usr/bin/sh
set -eu

command -v getprop >/dev/null 2>&1 || { echo 'Run this from Termux.' >&2; exit 1; }
ARCH=$(uname -m)
ANDROID=$(getprop ro.build.version.release 2>/dev/null || echo unknown)
API=$(getprop ro.build.version.sdk 2>/dev/null || echo unknown)
RAM_MB=$(awk '/MemTotal/{print int($2/1024)}' /proc/meminfo 2>/dev/null || echo unknown)
ROOT=no
[ "$(id -u)" = 0 ] && ROOT=yes
command -v su >/dev/null 2>&1 && su -c id >/dev/null 2>&1 && ROOT=yes
TERMUX_PREFIX=${PREFIX:-unknown}
PROOT=$(command -v proot-distro 2>/dev/null || true)

case "$ARCH" in
  aarch64|arm64) PLATFORM='ARM64: supported first-class target' ;;
  armv7l|armv8l|arm*) PLATFORM='ARM32: dependency availability must be verified; no full support claim' ;;
  x86_64|amd64) PLATFORM='x86_64: dependency availability must be verified; no full support claim' ;;
  *) PLATFORM='Unknown architecture: unsupported until tested' ;;
esac

echo 'WOSLand-Android compatibility report'
echo "Android: $ANDROID (API $API)"
echo "Architecture: $ARCH"
echo "RAM: ${RAM_MB} MB"
echo "Root available: $ROOT"
echo "Termux prefix: $TERMUX_PREFIX"
echo "proot-distro: ${PROOT:-not found}"
echo "Storage:"
df -h "${PREFIX:-/data/data/com.termux/files/usr}" 2>/dev/null || true
echo "Assessment: $PLATFORM"
echo 'This report is advisory. It does not install software or modify Android.'

