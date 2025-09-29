#!/usr/bin/env bash
# tools/new-script.sh
# Usage: tools/new-script.sh <name> [version] [description] [homepage]
#
# Crée un nouveau script à partir du template templates/script.sh.tpl
# - garantit LF (suppression CR)
# - rend le fichier exécutable
# - crée un fichier .sha256 avec le nom du fichier (format: "<sha256>  <basename>")
#
# Exemple:
#   tools/new-script.sh mon-nmap 1.2.3 "Mon scanner NMAP" "https://github.com/NoelNac-HackEthical/mes-scripts"

set -euo pipefail
IFS=$'\n\t'

# --- helpers ---
err() { printf '%s\n' "$*" >&2; }
usage() {
  cat <<EOF
Usage: $0 <name> [version] [description] [homepage]

Creates: ./<name> and ./<name>.sha256
Template: templates/script.sh.tpl
EOF
  exit 2
}

# Escape string for safe sed replacement (escapes / and & and backslashes)
_sed_escape() {
  # usage: _sed_escape "string"
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g'
}

# Write sha256 file in the format: "<lowerhex>  <basename>"
_write_sha256() {
  local file="$1"
  local base
  base="$(basename "$file")"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk -v f="$base" '{print tolower($1) "  " f}' > "$file.sha256"
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$file" | awk -v f="$base" '{print tolower($1) "  " f}' > "$file.sha256"
  else
    err "No sha256sum or shasum available; skipping .sha256 creation"
  fi
}

# --- arguments ---
[ $# -ge 1 ] || usage
NAME="$1"
VERSION="${2:-0.1.0}"
DESCRIPTION="${3:-A useful script}"
HOMEPAGE="${4:-https://github.com/NoelNac-HackEthical/mes-scripts}"

# template path (modifiable si tu veux)
TPL_PATH="templates/script.sh.tpl"
[ -f "$TPL_PATH" ] || { err "Template not found: $TPL_PATH"; exit 1; }

OUT="./$NAME"
if [ -e "$OUT" ]; then
  err "Target file already exists: $OUT"
  exit 1
fi

# prepare escaped values for sed
_e_name=$(_sed_escape "$NAME")
_e_version=$(_sed_escape "$VERSION")
_e_desc=$(_sed_escape "$DESCRIPTION")
_e_home=$(_sed_escape "$HOMEPAGE")

# Replace placeholders, remove CR (CRLF -> LF), write atomically to avoid partial files
tmp="$(mktemp "${TMPDIR:-/tmp}/newscript.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

# Use sed with escaped values; use @ as delimiter to reduce escaping noise
sed \
  -e "s@__NAME__@${_e_name}@g" \
  -e "s@__VERSION__@${_e_version}@g" \
  -e "s@__DESCRIPTION__@${_e_desc}@g" \
  -e "s@__HOMEPAGE__@${_e_home}@g" \
  "$TPL_PATH" \
  | sed 's/\r$//' > "$tmp"

# final move
mv "$tmp" "$OUT"
chmod +x "$OUT"
# ensure readable by user
chmod 744 "$OUT" || true

# create sha256 file
_write_sha256 "$OUT"

printf 'Created: %s and %s.sha256\n' "$OUT" "$OUT"
printf 'Try:   ./%s -h\n' "$NAME"
