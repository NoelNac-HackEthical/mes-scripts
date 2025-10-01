#!/usr/bin/env bash
# new-script.sh — Génère un nouveau script basé sur templates/script.sh.tpl
# Usage: tools/new-script.sh <name> <version> <description>

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <name> <version> <description>" >&2
  exit 1
fi

NAME="$1"
VERSION="$2"
DESCRIPTION="$3"

TPL="templates/script.sh.tpl"
OUT="./$NAME"

if [[ ! -f "$TPL" ]]; then
  echo "Template introuvable: $TPL" >&2
  exit 1
fi

# Génération du script à partir du template
sed \
  -e "s/{{NAME}}/${NAME}/g" \
  -e "s/{{VERSION}}/${VERSION}/g" \
  -e "s/{{DESCRIPTION}}/${DESCRIPTION}/g" \
  "$TPL" > "$OUT"

chmod +x "$OUT"

# Générer le .sha256 (empreinte seule)
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$OUT" | awk '{print $1}' > "${OUT}.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$OUT" | awk '{print $1}' > "${OUT}.sha256"
else
  echo "Avertissement: ni sha256sum ni shasum trouvés. ${OUT}.sha256 non créé." >&2
fi

echo "Created: $OUT and ${OUT}.sha256"
echo "Try:   ./$NAME -h"
