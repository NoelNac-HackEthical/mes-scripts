#!/usr/bin/env bash
# NAME=__NAME__
# VERSION=0.1.0
# DESCRIPTION=Short one-line description
# HOMEPAGE=https://github.com/NoelNac-HackEthical/mes-scripts

set -euo pipefail
IFS=$'\n\t'

show_version() {
  # Lit NAME et VERSION directement dans les en-têtes du script
  local self="${BASH_SOURCE[0]:-$0}"
  local name ver
  name="$(awk -F= '/^# *NAME=/{print $2; exit}' "$self")"
  ver="$(awk -F= '/^# *VERSION=/{print $2; exit}' "$self")"
  echo "${name:-__NAME__} ${ver:-0.0.1}"
}

show_help() {
  local self="${BASH_SOURCE[0]:-$0}"
  local desc
  desc="$(awk -F= '/^# *DESCRIPTION=/{print $2; exit}' "$self")"
  echo "$(basename "$self") — ${desc:-No description}"
  echo
  echo "Usage:"
  echo "  $(basename "$self") [OPTIONS]"
  echo
  echo "Options:"
  echo "  -V, --version   Show version and exit"
  echo "  -h, --help      Show this help and exit"
}

main() {
  case "${1:-}" in
    -V|--version) show_version; exit 0 ;;
    -h|--help)    show_help; exit 0 ;;
  esac

  echo "TODO: implémenter la logique du script"
}

main "$@"
