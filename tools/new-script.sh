#!/usr/bin/env bash
# tools/new-script.sh
#
# Usage:
#   tools/new-script.sh [--tags "scripts,tools"] [--category "Mes scripts"] [--slug "mon-slug"] [--draft true|false] \
#                       <name> <version> <description> <homepage>
#
# Exemple:
#   tools/new-script.sh --tags "scripts,tools" --category "Mes scripts" mon-nmap 1.0.0 \
#       "Scan nmap customisé" "https://github.com/NoelNac-HackEthical/mes-scripts"

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  tools/new-script.sh [OPTIONS] <name> <version> <description> <homepage>

Options:
  --tags "t1,t2"        Tags à écrire dans le header (# TAGS=…), par défaut: "scripts,tools"
  --category "Cat"      Catégorie à écrire (# CATEGORY=…), par défaut: "Mes scripts"
  --slug "mon-slug"     Slug forcé (# SLUG=…), par défaut: <name>
  --draft true|false    Valeur du draft (# DRAFT=…), par défaut: false
  -h, --help            Afficher cette aide

Arguments:
  <name>         Nom du script (fichier créé)
  <version>      Version du script
  <description>  Description courte (une ligne)
  <homepage>     URL de la page du dépôt/projet

Exemples:
  tools/new-script.sh mon-nmap 1.0.0 "Scan nmap customisé" "https://github.com/NoelNac-HackEthical/mes-scripts"
  tools/new-script.sh --tags "ctf,utils" --category "Mes scripts" test02 0.4.0 "outil test" "https://…"
EOF
}

# Valeurs par défaut
TAGS="scripts,tools"
CATEGORY="Mes scripts"
SLUG=""          # si vide, = NAME
DRAFT="false"

# Parse options
OPTS=()
while [[ $# -gt 0 ]]; do
  case "${1}" in
    --tags)
      [[ $# -ge 2 ]] || { echo "Erreur: --tags requiert une valeur." >&2; exit 1; }
      TAGS="${2}"; shift 2;;
    --category)
      [[ $# -ge 2 ]] || { echo "Erreur: --category requiert une valeur." >&2; exit 1; }
      CATEGORY="${2}"; shift 2;;
    --slug)
      [[ $# -ge 2 ]] || { echo "Erreur: --slug requiert une valeur." >&2; exit 1; }
      SLUG="${2}"; shift 2;;
    --draft)
      [[ $# -ge 2 ]] || { echo "Erreur: --draft requiert une valeur (true|false)." >&2; exit 1; }
      case "${2}" in
        true|false) DRAFT="${2}";;
        *) echo "Erreur: --draft doit être true ou false." >&2; exit 1;;
      esac
      shift 2;;
    -h|--help)
      usage; exit 0;;
    --) shift; break;;
    -*)
      echo "Option inconnue: ${1}" >&2; usage; exit 1;;
    *)
      OPTS+=("${1}"); shift;;
  esac
done

# Remettre les positionnels restants
set -- "${OPTS[@]}" "$@"

# Positionnels requis
NAME="${1:-}"; VERSION="${2:-}"; DESCRIPTION="${3:-}"; HOMEPAGE="${4:-}"
if [[ -z "${NAME}" || -z "${VERSION}" || -z "${DESCRIPTION}" || -z "${HOMEPAGE}" ]]; then
  echo "Erreur: arguments manquants." >&2
  usage
  exit 1
fi

TEMPLATE="templates/script.sh.tpl"
OUT="./${NAME}"

if [[ ! -f "${TEMPLATE}" ]]; then
  echo "Template introuvable: ${TEMPLATE}" >&2
  exit 1
fi

# Si pas de slug fourni, utiliser le nom
if [[ -z "${SLUG}" ]]; then
  SLUG="${NAME}"
fi

# Génération depuis le template
# 1er sed : variables {{...}} ; 2e sed : lignes de meta (# TAGS=, etc.)
sed \
  -e "s/{{NAME}}/${NAME}/g" \
  -e "s/{{VERSION}}/${VERSION}/g" \
  -e "s/{{DESCRIPTION}}/${DESCRIPTION}/g" \
  -e "s|{{HOMEPAGE}}|${HOMEPAGE}|g" \
  "${TEMPLATE}" \
| sed \
  -e "s|^# TAGS=.*$|# TAGS=${TAGS}|" \
  -e "s|^# CATEGORY=.*$|# CATEGORY=${CATEGORY}|" \
  -e "s|^# SLUG=.*$|# SLUG=${SLUG}|" \
  -e "s|^# DRAFT=.*$|# DRAFT=${DRAFT}|" \
> "${OUT}"

chmod +x "${OUT}"

# SHA256 (fichier .sha256 ne contenant que l'empreinte)
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "${OUT}" | awk '{print $1}' > "${OUT}.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "${OUT}" | awk '{print $1}' > "${OUT}.sha256"
else
  echo "Avertissement: ni sha256sum ni shasum n'ont été trouvés. ${OUT}.sha256 non créé." >&2
fi

echo "Created: ${OUT} and ${OUT}.sha256"
echo "Try:   ./${NAME} -h"
