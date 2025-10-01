#!/usr/bin/env bash
# tools/new-script.sh
#
# Usage: tools/new-script.sh <name> <version> <description> <homepage>
#
# Exemple:
#   tools/new-script.sh mon-nmap 1.0.1 "Short one-line description du script mon-nmap" "https://github.com/NoelNac-HackEthical/mes-scripts"

set -euo pipefail

NAME="${1:-}"
VERSION="${2:-}"
DESCRIPTION="${3:-}"
HOMEPAGE="${4:-}"

if [[ -z "$NAME" || -z "$VERSION" || -z "$DESCRIPTION" || -z "$HOMEPAGE" ]]; then
  echo "Usage: $0 <name> <version> <description> <homepage>" >&2
  exit 1
fi

TEMPLATE="templates/script.sh.tpl"
OUT="./$NAME"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template introuvable: $TEMPLATE" >&2
  exit 1
fi

# Remplacer les variables {{...}} dans le template
sed \
  -e "s/{{NAME}}/$NAME/g" \
  -e "s/{{VERSION}}/$VERSION/g" \
  -e "s/{{DESCRIPTION}}/$DESCRIPTION/g" \
  -e "s|{{HOMEPAGE}}|$HOMEPAGE|g" \
  "$TEMPLATE" > "$OUT"

chmod +x "$OUT"

# Créer le .sha256 correspondant (empreinte seule)
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$OUT" | awk '{print $1}' > "$OUT.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$OUT" | awk '{print $1}' > "$OUT.sha256"
else
  echo "Avertissement: ni sha256sum ni shasum trouvés. ${OUT}.sha256 non créé." >&2
fi

echo "Created: $OUT and $OUT.sha256"
echo "Try:   ./$NAME -h"
