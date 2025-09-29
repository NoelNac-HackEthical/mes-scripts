#!/usr/bin/env bash
# NAME=__NAME__
# VERSION=__VERSION__
# DESCRIPTION=__DESCRIPTION__
# HOMEPAGE=__HOMEPAGE__
#____________________________________________________________________________
#
# Bref résumé :
#   __DESCRIPTION__
#
# Template minimal pour scripts mes-scripts :
# - contient usage() et examples() en heredoc (extraits par la pipeline)
# - contient _version_str / _print_version_and_exit pour être cohérent
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers version (ne pas modifier)
_self_path="${BASH_SOURCE[0]:-$0}"
if command -v readlink >/dev/null 2>&1; then
  _resolved="$(readlink -f -- "$_self_path" 2>/dev/null || true)"
  [ -n "$_resolved" ] && _self_path="$_resolved"
fi
_self_base="$(basename "$_self_path")"

_version_str(){
  # lit la première occurrence '# VERSION='
  local v
  v="$(awk -F= '/^# *VERSION *=/ { gsub(/\r$/,"",$2); print $2; exit }' "$_self_path" 2>/dev/null || true)"
  v="${v:-0.0.0}"
  printf '%s %s\n' "$_self_base" "$v"
}
_print_version_and_exit(){ _version_str; exit 0; }
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# USAGE (heredoc) — extrait automatiquement par la pipeline
usage(){
  cat <<USAGE
$(basename "$0") __VERSION__

Usage: $(basename "$0") [OPTIONS] <args>

Short description:
  __DESCRIPTION__

Options:
  -h, --help     Show this help
  -V, --version  Show version
  --debug        Debug mode (set -x)
USAGE
}
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# EXAMPLES / ASTUCES (optionnel ; extrait si présent)
examples(){
  cat <<EXAMPLES
# Basic example
$(basename "$0") arg1 arg2

# Advanced example (edit as needed)
# $(basename "$0") --option value target
EXAMPLES
}
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Parsing minimal CLI (classique)
DEBUG=false

# Aides rapides
if [[ "${1:-}" == "--version" || "${1:-}" == "-V" ]]; then
  _print_version_and_exit
fi
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

# Boucle d'options basique (à compléter selon le script)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug) DEBUG=true; shift ;;
    -V|--version) _print_version_and_exit ;;
    -h|--help) _version_str; usage; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1"; usage; exit 2 ;;
    *) break ;;  # positions
  esac
done
# ---------------------------------------------------------------------------

_main(){
  # Exemple de squelette (remplacer par la logique du script généré)
  if [ "$DEBUG" = true ]; then set -x; fi

  echo "Script: $(_version_str)"
  echo "Args  : $*"

  # TODO: implémentation
  return 0
}

# Exécuter _main si appelé directement
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  _main "$@"
fi
