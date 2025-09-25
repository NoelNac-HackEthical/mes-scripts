#!/usr/bin/env bash
# tools/new-script.sh
# Usage: tools/new-script.sh <name> [version] [description]

set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <name> [version] [description]" >&2
  exit 1
fi
NAME="$1"
VERSION="${2:-0.1.0}"
DESCRIPTION="${3:-A useful script}"
HOMEPAGE="${HOMEPAGE:-https://github.com/NoelNac-HackEthical/mes-scripts}"

tpl="templates/script.sh.tpl"
[ -f "$tpl" ] || { echo "Template not found: $tpl" >&2; exit 1; }

out="./$NAME"
sed -e "s/__NAME__/${NAME}/g"         -e "s/__VERSION__/${VERSION}/g"         -e "s/__DESCRIPTION__/${DESCRIPTION}/g"         -e "s#__HOMEPAGE__#${HOMEPAGE}#g"         "$tpl" > "$out"
chmod +x "$out"

# create sha256 in LF
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$out" > "$out.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$out" | awk '{print tolower($1) "  " FILENAME}' FILENAME="$(basename "$out")" > "$out.sha256"
fi

echo "Created: $out and $out.sha256"
echo "Try:   ./$NAME -h"
