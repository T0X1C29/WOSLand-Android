#!/data/data/com.termux/files/usr/bin/sh
set -eu

APP=${WOSLAND_APP_DIR:-/root/python-wosland}
ARCHIVE=${1:?Usage: restore-database.sh VERIFIED_BACKUP_DIR}
DBDIR="$APP/db"
test -d "$ARCHIVE" || { echo "Backup directory not found: $ARCHIVE" >&2; exit 1; }
test ! -e "$HOME/.wosland-python.stop" || true
mkdir -p "$DBDIR"
for src in "$ARCHIVE"/*.sqlite; do
  [ -f "$src" ] || continue
  dst="$DBDIR/$(basename "$src")"
  test ! -e "$dst" || { echo "Refusing to overwrite existing database: $dst" >&2; exit 1; }
  cp -p "$src" "$dst"
done
echo "Restored database files into $DBDIR; run integrity and startup checks before removing any originals."
