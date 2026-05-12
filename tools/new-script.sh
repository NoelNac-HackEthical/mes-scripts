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
OUT="./dev/${NAME}-dev"

[[ -f "$TPL" ]] || { echo "Template introuvable: $TPL" >&2; exit 1; }
[[ -e "$OUT" ]] && { echo "Fichier déjà présent: $OUT" >&2; exit 2; }

# Échapper pour sed (on utilise | comme délimiteur + échappe &)
esc() { printf '%s' "$1" | sed -e 's/[&|]/\\&/g'; }
NAME_ESC=$(esc "$NAME")
VER_ESC=$(esc "$VERSION")
DESC_ESC=$(esc "$DESCRIPTION")

# Remplacement robuste
sed -e "s|{{NAME}}|$NAME_ESC|g" \
    -e "s|{{VERSION}}|$VER_ESC|g" \
    -e "s|{{DESCRIPTION}}|$DESC_ESC|g" \
    "$TPL" > "$OUT"

chmod +x "$OUT"

echo "Created: $OUT"
echo "→ Pense à éditer le bloc PRESENTATION_START/END dans $OUT"
echo "→ Le fichier .sha256 officiel sera généré par GitHub Actions lors de la release."