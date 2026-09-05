#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob nocaseglob

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

CHANGED_SLUGS=()

if [ -d "_inbox" ]; then
  for inbox_dir in _inbox/*/; do
    slug="$(basename "$inbox_dir")"
    post_dir="content/posts/$slug"

    if [ ! -d "$post_dir" ]; then
      echo "Warnung: kein Post '$slug' gefunden, überspringe $inbox_dir" >&2
      continue
    fi

    files=("$inbox_dir"*.HEIC "$inbox_dir"*.HEIF "$inbox_dir"*.jpg "$inbox_dir"*.jpeg "$inbox_dir"*.png)
    [ ${#files[@]} -eq 0 ] && continue

    echo "==> Verarbeite Fotos für '$slug'"

    n=1
    while [ -e "$post_dir/photo$n.jpg" ] || [ -e "$post_dir/photo$n.png" ]; do
      n=$((n + 1))
    done

    for f in "${files[@]}"; do
      [ -e "$f" ] || continue
      ext_lower="$(echo "${f##*.}" | tr '[:upper:]' '[:lower:]')"
      dest="$post_dir/photo$n.jpg"

      case "$ext_lower" in
        heic|heif)
          echo "    $f -> photo$n.jpg (HEIC, GPS wird übernommen)"
          heif-convert -q 90 "$f" "$dest" >/dev/null
          exiftool -TagsFromFile "$f" -all:all -overwrite_original "$dest" >/dev/null 2>&1
          ;;
        jpg|jpeg)
          echo "    $f -> photo$n.jpg"
          cp "$f" "$dest"
          ;;
        png)
          dest="$post_dir/photo$n.png"
          echo "    $f -> photo$n.png"
          cp "$f" "$dest"
          ;;
      esac

      rm "$f"
      n=$((n + 1))
    done

    CHANGED_SLUGS+=("$slug")
  done
fi

echo "==> Baue Tailwind CSS"
npm run build:css

echo "==> Baue Seite (Testlauf)"
rm -rf public resources/_gen
hugo --minify

echo "==> Build ok"

git add -A

if git diff --cached --quiet; then
  echo "Keine Änderungen zum Commiten."
  exit 0
fi

if [ ${#CHANGED_SLUGS[@]} -gt 0 ]; then
  MSG="Fotos hinzugefügt: ${CHANGED_SLUGS[*]}"
else
  MSG="Blog-Update"
fi

git commit -m "$MSG"
git push

echo "==> Fertig, Deploy läuft, in ein-zwei Minuten live"
