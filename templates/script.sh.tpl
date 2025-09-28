#!/usr/bin/env bash
# NAME=__NAME__
# VERSION=0.1.0
# DESCRIPTION=Short one-line description
# HOMEPAGE=https://github.com/NoelNac-HackEthical/mes-scripts

# ──────────────────────────────────────────────────────────────────────────────
# Safe shell options
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────────────────────
# Auto metadata (parsed from the header above)
SELF="${BASH_SOURCE[0]:-$0}"
VERSION="${VERSION:-$(grep -m1 -E '^#\s*VERSION='    "$SELF" | sed -E 's/^#\s*VERSION=//')}"
NAME="${NAME:-$(grep -m1 -E '^#\s*NAME='       "$SELF" | sed -E 's/^#\s*NAME=//')}"
DESCRIPTION="${DESCRIPTION:-$(grep -m1 -E '^#\s*DESCRIPTION=' "$SELF" | sed -E 's/^#\s*DESCRIPTION=//')}"
HOMEPAGE="${HOMEPAGE:-$(grep -m1 -E '^#\s*HOMEPAGE='   "$SELF" | sed -E 's#^#\s*HOMEPAGE=##')}"

: "${VERSION:=0.0.1}"
: "${NAME:=__NAME__}"
: "${DESCRIPTION:=Short one-line description}"
: "${HOMEPAGE:=https://github.com/NoelNac-HackEthical/mes-scripts}"

# ──────────────────────────────────────────────────────────────────────────────
# UI helpers
if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'; RED=$'\033[31m'; YELLOW=$'\033[33m'; RESET=$'\033[0m'
else
  BOLD=''; DIM=''; GREEN=''; RED=''; YELLOW=''; RESET=''
fi
die(){  echo -e "${RED}✖ $*${RESET}" >&2; exit 1; }
warn(){ echo -e "${YELLOW}!${RESET} $*"; }
log(){  echo -e "${DIM}•${RESET} $*"; }
ok(){   echo -e "${GREEN}✔${RESET} $*"; }

# ──────────────────────────────────────────────────────────────────────────────
# CLI / Help
show_version(){ echo "${NAME} ${VERSION}"; }
show_help(){
  cat <<'EOF'
__NAME__ — Short one-line description

Usage:
  __NAME__ [OPTIONS]

Options:
  -o, --out FILE        Output file (default: ./output.txt)
  -t, --target VALUE    Target (domain/host/path)
  --no-medium           Example flag (disable a medium set)
  -V, --version         Show version and exit
  -h, --help            Show this help and exit
EOF
}

OUT="./output.txt"
TARGET=""
NO_MEDIUM=0

while (($#)); do
  case "$1" in
    -o|--out)    OUT="${2:-}";     shift 2;;
    -t|--target) TARGET="${2:-}";  shift 2;;
    --no-medium) NO_MEDIUM=1;      shift 1;;
    -V|--version) show_version;    exit 0;;
    -h|--help)    show_help;       exit 0;;
    --) shift; break;;
    -*) die "Unknown option: $1";;
    *)  die "Unexpected argument: $1";;
  esac
done

# ──────────────────────────────────────────────────────────────────────────────
# Main
main() {
  log "Description : ${DESCRIPTION}"
  log "Homepage    : ${HOMEPAGE}"
  log "Output      : ${OUT}"
  log "Target      : ${TARGET:-<none>}"
  log "No-medium   : ${NO_MEDIUM}"

  # Example action:
  printf "%s v%s\n" "$NAME" "$VERSION" > "$OUT"
  ok "Done. Wrote: $OUT"
}

main "$@"
