#!/usr/bin/env bash
# Encrypts the manual and writes index.html for GitHub Pages.
# Usage: MOM_PASSWORD=... ./build.sh path/to/mamin-dom.html
# The plaintext page and the password never go into this repo.
set -euo pipefail
SRC="${1:?path to the plaintext mamin-dom.html}"
: "${MOM_PASSWORD:?set MOM_PASSWORD}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
# add manifest, icons and offline support to the page Mom sees after unlocking
python3 - "$SRC" "$HERE/src/head.html" "$TMP/index.html" <<'PY'
import sys
page, head, out = sys.argv[1:]
s = open(page, encoding="utf-8").read()
s = s.replace("</head>", open(head, encoding="utf-8").read() + "</head>", 1)
open(out, "w", encoding="utf-8").write(s)
PY
cd "$HERE"
npx --yes staticrypt@3.5.4 "$TMP/index.html" -d "$TMP/out" -p "$MOM_PASSWORD" --short \
  -c .staticrypt.json --remember 0 \
  --template-title "Мамин дом" \
  --template-instructions "Введи пароль. Его нужно ввести только один раз." \
  --template-placeholder "Пароль" \
  --template-button "Открыть" \
  --template-remember "Запомнить на этом телефоне" \
  --template-error "Неверный пароль. Попробуй ещё раз." \
  --template-toggle-show "Показать пароль" \
  --template-toggle-hide "Скрыть пароль" \
  --template-color-primary "#1f6f78" \
  --template-color-secondary "#f3f6f7"
# same manifest/icons/offline tags on the password screen
python3 - "$TMP/out/index.html" "$HERE/src/head.html" "$HERE/index.html" <<'PY'
import sys
page, head, out = sys.argv[1:]
s = open(page, encoding="utf-8").read()
s = s.replace("</head>", open(head, encoding="utf-8").read() + "</head>", 1)
open(out, "w", encoding="utf-8").write(s)
PY
rm -rf "$TMP"
echo "Built index.html"
