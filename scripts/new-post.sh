#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [ -z "${1:-}" ]; then
  read -rp "Slug für neuen Post (z.B. ausflug-sintra): " SLUG
else
  SLUG="$1"
fi

if [ -z "$SLUG" ]; then
  echo "Kein Slug angegeben, Abbruch." >&2
  exit 1
fi

POST_DIR="content/posts/$SLUG"
INBOX_DIR="_inbox/$SLUG"

if [ -e "$POST_DIR" ]; then
  echo "Post '$SLUG' existiert bereits: $POST_DIR" >&2
  exit 1
fi

hugo new "content/posts/$SLUG/index.md"
mkdir -p "$INBOX_DIR"

echo ""
echo "Post angelegt:  $REPO_ROOT/$POST_DIR/index.md"
echo "Fotos-Inbox:    $REPO_ROOT/$INBOX_DIR/  (auch HEIC einfach reinziehen)"
echo ""
echo "Text in VS Code schreiben, Fotos in die Inbox ziehen, dann 'publish' ausführen."

if command -v code >/dev/null 2>&1; then
  code "$REPO_ROOT/$POST_DIR/index.md"
fi
