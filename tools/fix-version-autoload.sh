#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

DRY_RUN=0
DO_BUMP=1
ONLY=()

while (($#)); do
  case "$1" in
    --dry-run) DRY_RUN=1; shift;;
    --no-bump) DO_BUMP=0; shift;;
    --only)    shift; while (($#)) && [[ "$1" != --* ]]; do ONLY+=("$1"); shift; done;;
    -h|--help) grep -E '^(# |Usage:)' "$0"; exit 0;;
    *) echo "Arg inconnu: $1" >&2; exit 1;;
  esac
done

log(){ echo "• $*"; }
warn(){ echo "!? $*" >&2; }
die(){ echo "✖ $*" >&2; exit 1; }

collect_scripts(){
  if ((${#ONLY[@]})); then
    printf '%s\n' "${ONLY[@]}"
    return
  fi
  git ls-files \
  | grep -v -E '^(.github/|templates/|tools/|README|LICENSE)' \
  | grep -v -E '\.sha256$' \
  | while IFS= read -r f; do
      [ -f "$f" ] || continue
      head -n1 "$f" | grep -q '^#!' || continue
      grep -q -m1 -E '^#\s*VERSION=' "$f" || continue
      printf '%s\n' "$f"
    done
}

AUTO_MARK='### AUTO-METADATA (do not remove)'
read -r -d '' AUTO_BLOCK <<'EOF' || true
### AUTO-METADATA (do not remove)
# Auto metadata derived from header lines above
SELF="${BASH_SOURCE[0]:-$0}"
VERSION="${VERSION:-$(grep -m1 -E '^#\s*VERSION='    "$SELF" | sed -E 's/^#\s*VERSION=//')}"
NAME="${NAME:-$(grep -m1 -E '^#\s*NAME='       "$SELF" | sed -E 's/^#\s*NAME=//')}"
DESCRIPTION="${DESCRIPTION:-$(grep -m1 -E '^#\s*DESCRIPTION=' "$SELF" | sed -E 's/^#\s*DESCRIPTION=//')}"
HOMEPAGE="${HOMEPAGE:-$(grep -m1 -E '^#\s*HOMEPAGE='   "$SELF" | sed -E 's#^#\s*HOMEPAGE=##')}"
: "${VERSION:=0.0.1}"
: "${NAME:=__NAME__}"
: "${DESCRIPTION:=Short one-line description}"
: "${HOMEPAGE:=https://github.com/NoelNac-HackEthical/mes-scripts}"
### END AUTO-METADATA
EOF

insert_auto_block() {
  local f="$1"
  if grep -q "$AUTO_MARK" "$f"; then
    echo "  = auto-meta: déjà présent"
    return
  fi
  local L
  if grep -nE "^IFS=" "$f" >/dev/null; then
    L=$(grep -nE "^IFS=" "$f" | head -n1 | cut -d: -f1); L=$((L+1))
  elif grep -nE "^set -euo pipefail" "$f" >/dev/null; then
    L=$(grep -nE "^set -euo pipefail" "$f" | head -n1 | cut -d: -f1); L=$((L+1))
  else
    L=2
  fi
  if ((DRY_RUN)); then
    echo "  ~ insertion auto-meta (ligne $L)"
  else
    awk -v n="$L" -v txt="$AUTO_BLOCK\n" 'NR==n{printf "%s", txt} 1' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    echo "  + inséré auto-meta"
  fi
}

remove_body_assigns(){
  local f="$1"
  local expr='^(NAME|VERSION|DESCRIPTION|HOMEPAGE)=\".*\"[[:space:]]*$'
  if ((DRY_RUN)); then
    if grep -nE "$expr" "$f" >/dev/null; then
      echo "  ~ lignes à retirer:"
      grep -nE "$expr" "$f" || true
    else
      echo "  = aucune assignation redondante"
    fi
  else
    sed -i -E "s/$expr//" "$f"
    awk 'NF || !blank++' blank=0 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    echo "  - assignations supprimées"
  fi
}

bump_version_header(){
  local f="$1"
  local line; line=$(grep -m1 -nE '^#\s*VERSION=' "$f" || true)
  [[ -n "$line" ]] || { warn "  ! pas de # VERSION= trouvé"; return; }
  local n cur; n=${line%%:*}; cur=${line#*:}
  local ver=${cur#*VERSION=}
  if [[ "$ver" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(.*)$ ]]; then
    local maj=${BASH_REMATCH[1]} min=${BASH_REMATCH[2]} pat=${BASH_REMATCH[3]} suf=${BASH_REMATCH[4]}
    local new="$maj.$((min+1)).$pat$suf"
    if ((DRY_RUN)); then
      echo "  ~ bump: $ver -> $new"
    else
      awk -v n="$n" -v newver="$new" 'NR==n { sub(/VERSION=.*/, "VERSION=" newver) } { print }' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
      echo "  + bump: $ver -> $new"
    fi
  else
    warn "  ! format version non supporté: $ver"
  fi
}

main(){
  local any=0
  # pas de process substitution : on boucle sur la liste "à l'ancienne"
  while IFS= read -r f; do
    # strip CR éventuel
    f="${f%$'\r'}"
    ((any++))
    echo "▶ $f"
    insert_auto_block "$f"
    remove_body_assigns "$f"
    (( DO_BUMP )) && bump_version_header "$f" || echo "  = bump ignoré (--no-bump)"
    echo
  done < <(collect_scripts)

  (( any )) || die "Aucun script détecté."
  (( DRY_RUN )) || echo "Conseil: git add -A && git commit -m 'chore: auto-meta + bump minor'"
}

main "$@"
