#!/usr/bin/env bash
set -euo pipefail

URL="http://dog.htb/FUZZ"                      # adapte ou passe en argument
WORDLIST="/usr/share/wordlists/dirb/big.txt"   # adapte ou passe en argument
THREADS=50
FILTER_CODE=404
OUTBASE="ffuf_out"                              # préfixe des fichiers (sans extension)
OUTDIR="."                                      # ex: "mes_scans"

mkdir -p "$OUTDIR"

JSON="$OUTDIR/${OUTBASE}.json"
TXT="$OUTDIR/${OUTBASE}.txt"
HITS="$OUTDIR/${OUTBASE}_hits.txt"

# 1) Export JSON (fiable)
ffuf -u "$URL" \
  -w "$WORDLIST" \
  -t "$THREADS" -fc "$FILTER_CODE" \
  -of json -o "$JSON"

# 2) Reconstitution "style console" depuis JSON
{
  echo "ffuf results"
  echo
  echo "URL: $URL"
  echo "Wordlist: $WORDLIST"
  echo "Threads: $THREADS  Filter: $FILTER_CODE"
  echo "------------------------------------------------"
  echo

  jq -r '
    .results[]
    | "\(.input.FUZZ)\t[Status: \(.status), Size: \(.length), Words: \(.words), Lines: \(.lines), Duration: \(.duration)]"
  ' "$JSON" | column -t -s $'\t'
} > "$TXT"

# 3) Hits-only (optionnel : ici c’est la même liste sans header)
jq -r '
  .results[]
  | "\(.input.FUZZ)\t[Status: \(.status), Size: \(.length), Words: \(.words), Lines: \(.lines), Duration: \(.duration)]"
' "$JSON" | column -t -s $'\t' > "$HITS"

echo "[OK] JSON: $JSON"
echo "[OK] TXT : $TXT"
echo "[OK] HITS: $HITS"
