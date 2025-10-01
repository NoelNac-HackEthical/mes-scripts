name: release-aggregate

on:
  push:
    branches: [ "main" ]
    paths:
      - "*"
      - "!README*"
      - "!LICENSE*"
      - "!.github/**"
      - "!templates/**"
      - "!tools/**"
  workflow_dispatch: {}

permissions:
  contents: write   # tags + releases

concurrency:
  group: release-aggregate
  cancel-in-progress: false

jobs:
  build-release:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set timezone (Europe/Brussels)
        run: sudo timedatectl set-timezone Europe/Brussels

      - name: Prepare environment
        run: |
          sudo apt-get update -y
          sudo apt-get install -y jq curl

      # Ton script existant qui fabrique/agrège la release
      - name: Aggregate & publish release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          RETAIN: "5"            # garder uniquement les 5 dernières releases (si géré par ton script)
          BRANCH_DEFAULT: "main"
        run: |
          bash .github/scripts/aggregate_release.sh

      # Construire le payload: URLs + VERSION + DESCRIPTION + USAGE
      - name: Build payload for hugo site (with asset URLs + script versions + descriptions + usage)
        id: build_payload
        shell: bash
        run: |
          set -euo pipefail

          REPO="${{ github.repository }}"  # ex: NoelNac-HackEthical/mes-scripts
          API="https://api.github.com/repos/${REPO}/releases/latest"

          # Récupérer le JSON de la release "latest"
          JSON="$(curl -sSL -H "Accept: application/vnd.github+json" "$API")"
          TAG="$(echo "$JSON" | jq -r '.tag_name')"

          # Assets (name + browser_download_url)
          ASSETS_JSON="$(echo "$JSON" | jq -c '[.assets[] | {name: .name, url: .browser_download_url}]')"

          # Scripts = noms sans .sha256
          SCRIPTS_JSON="$(echo "$ASSETS_JSON" | jq -r '[.[].name] | map(select(test("\\.sha256$")|not))')"

          # Map initiale { "script": {"url":"...", "sha256":"..."} }
          MAP="$(jq -n --argjson assets "$ASSETS_JSON" '
            ($assets | map(select(.name|test("\\.sha256$")|not))) as $bins
            | ($assets | map(select(.name|test("\\.sha256$")))) as $hashes
            | reduce $bins[] as $b ({}; .[$b.name] = {url: $b.url})
            | reduce $hashes[] as $h (.;
                .[ ($h.name|sub("\\.sha256$";"")) ] += {sha256: $h.url}
              )
          ')"

          TMPDIR="$(mktemp -d)"
          cleanup(){ rm -rf "$TMPDIR"; }
          trap cleanup EXIT

          for s in $(echo "$SCRIPTS_JSON" | jq -r '.[]'); do
            url="$(echo "$MAP" | jq -r --arg s "$s" '.[$s].url')"
            ver="unknown"; desc=""; usage_block=""
            if [ -n "$url" ] && curl -sSL "$url" -o "$TMPDIR/$s"; then
              # VERSION
              ver="$(awk -F= '/^# *VERSION *=/ { gsub(/\r$/,"",$2); print $2; exit }' "$TMPDIR/$s" 2>/dev/null || true)"
              ver="${ver:-unknown}"
              # DESCRIPTION
              desc="$(awk -F= '/^# *DESCRIPTION *=/ { gsub(/\r$/,"",$2); print $2; exit }' "$TMPDIR/$s" 2>/dev/null || true)"
              desc="${desc:-}"
              desc="$(echo "$desc" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"

              # USAGE (extraire le contenu du heredoc dans la fonction usage())
              # 1) Extraire le corps de la fonction usage() (entre 'usage(){' et la '}' correspondante)
              body="$(awk '
                /^usage[[:space:]]*\(\)[[:space:]]*{/ {infun=1; next}
                infun && /^\}[[:space:]]*$/ {infun=0; exit}
                infun
              ' "$TMPDIR/$s")"
              # 2) Retirer la ligne "cat <<USAGE" et la ligne "USAGE" (délimiteurs)
              usage_block="$(printf "%s\n" "$body" | sed -e '/cat <<USAGE/d' -e '/^USAGE$/d')"
              # Trim CR éventuels
              usage_block="$(printf "%s" "$usage_block" | sed 's/\r$//')"
            fi

            MAP="$(echo "$MAP" | jq --arg s "$s" --arg v "$ver" --arg d "$desc" --arg u "$usage_block" \
              '.[$s].version = $v | .[$s].description = $d | .[$s].usage = $u')"
          done

          # Payload final
          printf '{"source_repo":"%s","release_tag":"%s","scripts":%s,"assets":%s}\n' \
            "$REPO" "$TAG" "$SCRIPTS_JSON" "$MAP" > payload.json

          echo "Payload built:"
          cat payload.json

      # Envoi à hugo-demo (no clone)
      - name: Dispatch to hugo site (no clone)
        env:
          TARGET_HUGO_REPO: ${{ vars.TARGET_HUGO_REPO }}       # ex: NoelNac-HackEthical/hugo-demo
          HUGO_DEMO_TOKEN: ${{ secrets.HUGO_DEMO_TOKEN }}      # PAT classic scope public_repo
        shell: bash
        run: |
          set -euo pipefail

          OWNER="$(echo "$TARGET_HUGO_REPO" | cut -d/ -f1)"
          NAME="$(echo "$TARGET_HUGO_REPO" | cut -d/ -f2)"
          BODY=$(printf '{"event_type":"mes-scripts-release","client_payload":%s}' "$(cat payload.json)")

          HTTP_CODE="$(curl -sS -o /tmp/resp.json -w '%{http_code}' -X POST \
            -H 'Accept: application/vnd.github+json' \
            -H "Authorization: Bearer ${HUGO_DEMO_TOKEN}" \
            "https://api.github.com/repos/${OWNER}/${NAME}/dispatches" \
            -d "$BODY")"

          echo "HTTP: $HTTP_CODE"
          cat /tmp/resp.json || true

          case "$HTTP_CODE" in
            204) echo "repository_dispatch envoyé avec succès." ;;
            *) echo "::error ::Échec repository_dispatch (HTTP $HTTP_CODE)"; exit 1 ;;
          esac
