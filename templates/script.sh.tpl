#!/usr/bin/env bash
# NAME={{NAME}}
# VERSION={{VERSION}}
# DESCRIPTION={{DESCRIPTION}}
# HOMEPAGE={{HOMEPAGE}}
#____________________________________________________________________________
#
# Bref résumé :
#   {{DESCRIPTION}}
#
# Template minimal pour scripts mes-scripts :
# - contient usage() et examples() en heredoc (extraits par la pipeline)
# - contient _version_str / _print_version_and_exit pour être cohérent
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Basic metadata helpers (ne pas toucher)
_self_path="${BASH_SOURCE[0]:-$0}"
if command -v readlink >/dev/null 2>&1; then
  _resolved="$(readlink -f -- "$_self_path" 2>/dev/null || true)"
  [ -n "$_resolved" ] && _self_path="$_resolved"
fi
_self_base="$(basename "$_self_path")"

_version_str() {
  # lit la première occurrence '# VERSION=...'
  local v
  v="$(awk -F= '/^# *VERSION *=/ { gsub(/\r$/,"",$2); print $2; exit }' "$_self_path" 2>/dev/null || true)"
  v="${v:-0.0.0}"
  printf '%s %s\n' "$_self_base" "$v"
}
_print_version_and_exit() { _version_str; exit 0; }
# ---------------------------------------------------------------------------

# --------------------------
# Usage (heredoc) — obligatoire dans le template
usage(){
  cat <<USAGE
Usage: $(basename "$0") [OPTIONS] <args>

Short description:
  {{DESCRIPTION}}

Options:
  -h, --help     Show this help
  -V, --version  Show version
  --debug        Debug mode (set -x)
USAGE
}
# --------------------------

# --------------------------
# Examples / astuces (heredoc) — optionnel mais recommandé
examples(){
  cat <<EXAMPLES
# Basic example
$(basename "$0") arg1 arg2

# Advanced example (fill as needed)
# $(basename "$0") --option value target

EXAMPLES
}
# --------------------------

# --------------------------
# Common CLI parsing (minimal)
DEBUG=false

# quick args check (respect _print_version_and_exit and usage)
if [[ "${1:-}" == "--version" || "${1:-}" == "-V" ]]; then
  _print_version_and_exit
fi
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  _version_str
  usage
  exit 0
fi

# Basic option loop (extend in the concrete script)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug) DEBUG=true; shift ;;
    -V|--version) _print_version_and_exit ;;
    -h|--help) _version_str; usage; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1"; usage; exit 2 ;;
    *) break ;;  # leave positional args for the script
  esac
done
# --------------------------

# --------------------------
# Example main — to be adapted in generated scripts
_main(){
  # Example: simply echo args
  if [ "${DEBUG:-false}" = "true" ]; then
    set -x
  fi

  echo "Script: $(_version_str)"
  echo "Args: $*"

  # Put the real behavior here in generated script
  return 0
}
# --------------------------

# If the template is used to generate a real script, replace the _main body.
# Run main if script invoked directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  _main "$@"
fi
