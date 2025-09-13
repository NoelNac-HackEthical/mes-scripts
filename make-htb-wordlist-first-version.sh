#!/usr/bin/env bash
set -euo pipefail

# make-htb-wordlist.sh (v2.3)
# - Fusion FAST + Seclists (DNS top5000 + raft-small + option raft-medium)
# - Filtrage CTF-friendly (charset, longueur, pas de --, etc.)
# - Déduplication en préservant l'ordre
# - Modes :
#   * simple  : --limit N --out FILE
#   * batch   : --batch "1000,2000,5000" [--destdir DIR] [--basename NAME]
#
# Noms par défaut en batch : DIR/NAME-<N>.txt (ex: /usr/share/wordlists/htb-dns-vh-2000.txt)

OUT="/usr/share/wordlists/htb-subdomains-extended.txt"
AUTO_INSTALL=1
WITH_MEDIUM=0
LIMIT=0
MINLEN=3
MAXLEN=24
ALLOW_DIGIT_START=0
BATCH=""
DESTDIR="/usr/share/wordlists"
BASENAME="htb-dns-vh"

usage() {
  cat <<EOF
Usage:
  Mode simple (1 fichier) :
    $0 [--with-medium] [--limit N] [--minlen N] [--maxlen N] [--allow-digit-start] [--no-install] --out FILE

  Mode batch (plusieurs fichiers) :
    $0 --batch "1000,2000,5000" [--with-medium] [--minlen N] [--maxlen N] [--allow-digit-start] [--no-install] [--destdir DIR] [--basename NAME]

Exemples :
  $0 --no-install --with-medium --limit 2000 --out ~/HTB/tests/htb-dns-vh-2000.txt
  sudo $0 --batch "1000,2000,5000" --with-medium --destdir /usr/share/wordlists --basename htb-dns-vh
EOF
}

need() { command -v "$1" >/dev/null 2>&1; }

# --- parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) shift; OUT="${1:-}"; shift || true ;;
    --no-install) AUTO_INSTALL=0; shift ;;
    --with-medium) WITH_MEDIUM=1; shift ;;
    --limit) shift; LIMIT="${1:-0}"; shift || true ;;
    --minlen) shift; MINLEN="${1:-3}"; shift || true ;;
    --maxlen) shift; MAXLEN="${1:-24}"; shift || true ;;
    --allow-digit-start) ALLOW_DIGIT_START=1; shift ;;
    --batch) shift; BATCH="${1:-}"; shift || true ;;
    --destdir) shift; DESTDIR="${1:-}"; shift || true ;;
    --basename) shift; BASENAME="${1:-}"; shift || true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "[!] Option inconnue: $1" >&2; usage; exit 1 ;;
  esac
done

ensure_seclists() {
  local dns_list="/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt"
  local raft_small="/usr/share/seclists/Discovery/Web-Content/raft-small-words.txt"
  local raft_medium="/usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt"
  local missing=0
  [[ -f "$dns_list" ]] || missing=1
  [[ -f "$raft_small" ]] || missing=1
  if [[ $WITH_MEDIUM -eq 1 && ! -f "$raft_medium" ]]; then missing=1; fi
  if [[ $missing -eq 0 ]]; then return 0; fi
  if [[ $AUTO_INSTALL -eq 0 ]]; then
    echo "[!] Seclists manquantes et --no-install activé. Abandon." >&2
    exit 1
  fi
  if need apt; then
    echo "[-] Installation Seclists (sudo)…"
    sudo apt update -y && sudo apt install -y seclists
  else
    echo "[!] Apt indisponible. Installe 'seclists' manuellement." >&2
    exit 1
  fi
}

ensure_seclists

DNS_LIST="/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt"
RAFT_SMALL="/usr/share/seclists/Discovery/Web-Content/raft-small-words.txt"
RAFT_MEDIUM="/usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt"

# --- FAST intégré ---
TMP_FAST="$(mktemp)"
cat > "$TMP_FAST" <<'EOF'
admin
test
dev
staging
stage
preprod
prod
beta
alpha
demo
portal
internal
intranet
secure
private
public
local
backup
legacy
old
new
draft
tmp
api
app
apps
auth
sso
vpn
mail
ftp
git
gitea
gitlab
repo
db
mysql
postgres
mongo
redis
ldap
kibana
grafana
dashboard
monitor
status
health
log
logs
elk
user
users
account
accounts
login
signin
register
signup
profile
console
cp
panel
control
management
manager
cms
wp
wp-admin
phpmyadmin
sandbox
lab
labs
files
static
cdn
img
images
media
docs
help
support
ticket
tickets
jira
wiki
forum
chat
slack
upload
uploads
download
downloads
debug
hidden
secret
flag
ctf
owa
k8s
api1
api2
dev1
dev2
test1
test2
qa
uat
stage1
stage2
EOF

# --- Concaténation (ordre = priorité) ---
SOURCES=("$TMP_FAST" "$DNS_LIST" "$RAFT_SMALL")
[[ $WITH_MEDIUM -eq 1 ]] && SOURCES+=("$RAFT_MEDIUM")

echo "[-] Sources incluses :"
for s in "${SOURCES[@]}"; do
  printf '   - %s (%s lignes)\n' "$s" "$(wc -l < "$s" | tr -d ' ')"
done

TMP_CAT="$(mktemp)"
cat "${SOURCES[@]}" | tr '[:upper:]' '[:lower:]' > "$TMP_CAT"

# --- Filtrage strict ---
FILTERED="$(mktemp)"
awk -v min="$MINLEN" -v max="$MAXLEN" -v allow_digit_start="$ALLOW_DIGIT_START" '
  {
    x=$0
    sub(/#.*/,"",x)
    gsub(/^[[:space:]]+|[[:space:]]+$/,"",x)
    if (x=="") next
    if (x ~ /[^a-z0-9-]/) next
    if (x ~ /^-/) next
    if (x ~ /-$/) next
    if (x ~ /--/) next
    if (length(x) < min || length(x) > max) next
    if (!allow_digit_start && x !~ /^[a-z]/) next
    print x
  }
' "$TMP_CAT" > "$FILTERED"

# --- Dédup ordonnée ---
ORDERED_UNIQ="$(mktemp)"
awk '!seen[$0]++' "$FILTERED" > "$ORDERED_UNIQ"

TOTAL_BEFORE="$(wc -l < "$TMP_CAT" | tr -d ' ')"
TOTAL_AFTER="$(wc -l < "$ORDERED_UNIQ" | tr -d ' ')"
echo "[-] Comptes: avant filtrage=${TOTAL_BEFORE}, après filtrage=${TOTAL_AFTER}"

write_one() {
  local limit="$1"
  local out="$2"
  local dir; dir="$(dirname "$out")"
  if [[ ! -w "$dir" ]]; then
    echo "[-] Écriture avec sudo : $out"
    sudo mkdir -p "$dir"
    if [[ "$limit" -gt 0 ]]; then
      head -n "$limit" "$ORDERED_UNIQ" | sudo tee "$out" >/dev/null
    else
      sudo cp "$ORDERED_UNIQ" "$out"
    fi
    sudo chmod 644 "$out"
  else
    mkdir -p "$dir"
    if [[ "$limit" -gt 0 ]]; then
      head -n "$limit" "$ORDERED_UNIQ" > "$out"
    else
      cp "$ORDERED_UNIQ" "$out"
    fi
    chmod 644 "$out"
  fi
  echo "[+] Écrit : $out"
}

if [[ -n "$BATCH" ]]; then
  # Mode batch : génère plusieurs fichiers nommés BASENAME-<N>.txt
  IFS=',' read -r -a LIMARR <<< "$BATCH"
  for raw in "${LIMARR[@]}"; do
    lim="$(echo "$raw" | tr -d ' ')"
    [[ "$lim" =~ ^[0-9]+$ ]] || { echo "[!] Limite invalide: $lim" >&2; exit 1; }
    OUTFILE="${DESTDIR%/}/${BASENAME}-${lim}.txt"
    write_one "$lim" "$OUTFILE"
  done
else
  # Mode simple : --limit + --out
  if [[ "$LIMIT" -le 0 || -z "$OUT" ]]; then
    echo "[!] En mode simple, fournis --limit N et --out FILE (ou utilise --batch)."
    exit 1
  fi
  write_one "$LIMIT" "$OUT"
fi

echo "[-] Aperçu :"
if [[ -n "$BATCH" ]]; then
  for raw in "${LIMARR[@]}"; do
    lim="$(echo "$raw" | tr -d ' ')"
    out="${DESTDIR%/}/${BASENAME}-${lim}.txt"
    echo "  > $out (top 10)"
    head -n 10 "$out" | sed 's/^/    /'
  done
else
  echo "  > $OUT (top 10)"
  head -n 10 "$OUT" | sed 's/^/    /'
fi

# Nettoyage
rm -f "$TMP_FAST" "$TMP_CAT" "$FILTERED" "$ORDERED_UNIQ"
