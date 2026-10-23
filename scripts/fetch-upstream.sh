#!/data/data/com.termux/files/usr/bin/sh
set -eu

DEST=${WOSLAND_APP_DIR:-/root/python-wosland}
REPO=${WOSLAND_REPO:-https://github.com/whiteout-project/bot.git}
COMMIT=${WOSLAND_COMMIT:-e7a453088575b4cd00affca307fb3c9814f9e763}

command -v git >/dev/null 2>&1 || { echo 'git is required.' >&2; exit 1; }
if [ -e "$DEST" ]; then
  echo "Refusing to overwrite existing path: $DEST" >&2
  exit 1
fi
git clone "$REPO" "$DEST"
cd "$DEST"
git checkout --detach "$COMMIT"
test "$(git rev-parse HEAD)" = "$COMMIT" || { echo 'Commit verification failed.' >&2; exit 1; }
echo "Fetched upstream commit $COMMIT"

