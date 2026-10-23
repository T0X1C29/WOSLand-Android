#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail() { echo "FAIL: $*" >&2; exit 1; }

run_case() {
  arch=$1
  expected=$2
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT HUP INT TERM
  mkdir "$tmp/bin"
  cat > "$tmp/bin/getprop" <<'EOF'
#!/usr/bin/env sh
case "$1" in
  ro.build.version.release) echo 16 ;;
  ro.build.version.sdk) echo 36 ;;
  *) echo unknown ;;
esac
EOF
  cat > "$tmp/bin/uname" <<EOF
#!/usr/bin/env sh
[ "\$1" = -m ] && echo '$arch' || /usr/bin/uname "\$@"
EOF
  chmod +x "$tmp/bin/getprop" "$tmp/bin/uname"
  output=$(PATH="$tmp/bin:/usr/bin:/bin" sh "$ROOT/scripts/compatibility-check.sh") || fail "compatibility checker failed for $arch"
  echo "$output" | grep -F "$expected" >/dev/null || fail "unexpected assessment for $arch"
  rm -rf "$tmp"
  trap - EXIT HUP INT TERM
}

run_case aarch64 'ARM64: supported first-class target'
run_case armv7l 'ARM32: dependency availability must be verified'
run_case x86_64 'x86_64: dependency availability must be verified'
run_case mips64 'Unknown architecture: unsupported until tested'
echo 'PASS: Android/Termux command simulation'
