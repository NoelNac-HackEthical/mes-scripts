#!/usr/bin/env bash
# NAME=__NAME__
# VERSION=__VERSION__
# DESCRIPTION=__DESCRIPTION__
# HOMEPAGE=__HOMEPAGE__
#____________________________________________________________________________

set -euo pipefail
IFS=$'\n\t'

# --- version helpers ---
_self_path="${BASH_SOURCE[0]:-$0}"
# si possible, résoudre les symlinks pour afficher le nom réel du fichier
if command -v readlink >/dev/null 2>&1; then
  _resolved="$(readlink -f -- "$_self_path" 2>/dev/null || true)"
  [ -n "$_resolved" ] && _self_path="$_resolved"
fi
_self_base="$(basename "$_self_path")"

_version_str() {
  # récupère la première ligne '# VERSION=...' (tolère espaces autour de '=' et CRLF)
  local v
  v="$(awk -F= '/^# *VERSION *=/ { gsub(/\r$/,"",$2); print $2; exit }' "$_self_path" 2>/dev/null || true)"
  [ -n "$v" ] || v="0.0.0"
  printf '%s %s\n' "$_self_base" "$v"
}

_print_version_and_exit() { _version_str; exit 0; }
# -----------------------
# Compat: ancien nom de fonction
show_version() { _print_version_and_exit; }

# --- header helpers (NAME/DESCRIPTION/HOMEPAGE) ---
_get_header() {
  # Usage: _get_header NAME|DESCRIPTION|HOMEPAGE
  local key="$1" val
  val="$(awk -F= -v k="$key" '$0 ~ "^# *"k" *=" { gsub(/\r$/,"",$2); print $2; exit }' "$_self_path" 2>/dev/null || true)"
  printf '%s' "$val"
}

_show_help() {
  local name desc home
  name="$(_get_header NAME)"; [ -n "$name" ] || name="$_self_base"
  desc="$(_get_header DESCRIPTION)"
  home="$(_get_header HOMEPAGE)"
  cat <<EOF
$name - $desc

USAGE
  $name [options] [args]

OPTIONS
  -h, --help       Show this help
  -v, --version    Show version

HOMEPAGE
  $home
EOF
}

# --- main logic (à adapter) ---
main() {
  # Parse options
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|--help) _show_help; exit 0 ;;
      -v|--version) _print_version_and_exit ;;
      --) shift; break ;;
      -*) echo "Unknown option: $1" >&2; echo; _show_help; exit 2 ;;
      *)  break ;;
    esac
  done

  # TODO: implémenter la logique du script
  echo "TODO: implémenter la logique du script"
}

main "$@"
