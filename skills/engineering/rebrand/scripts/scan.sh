#!/usr/bin/env bash
# Scan a repository for every known variant of a brand name and group the
# hits by file plus by likely category. READ-ONLY: never edits anything.
#
# Usage: scan.sh [options] <old-brand> [path]
#   -w, --word          match whole words only
#   -a, --all           include hidden + git-ignored (generated/vendored) files
#   -L, --files         list matching files only
#   -c, --count         per-file counts (default)
#   -d, --detail        show matching lines with line numbers
#   -s, --summary       print total match count only
#   -x, --exclude GLOB  extra exclusion glob (repeatable)
#   -h, --help
set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode="count"; word=""; all=""; extra=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -w|--word) word="-w" ;;
    -a|--all) all="1" ;;
    -L|--files) mode="files" ;;
    -c|--count) mode="count" ;;
    -d|--detail) mode="detail" ;;
    -s|--summary) mode="summary" ;;
    -x|--exclude) shift; extra+=("-g" "!$1") ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; exit 2 ;;
    *) break ;;
  esac
  shift
done

brand="${1:-}"; [ -n "$brand" ] || { echo "Usage: scan.sh [options] <old-brand> [path]" >&2; exit 2; }
path="${2:-.}"

command -v rg >/dev/null 2>&1 || { echo "ripgrep (rg) is required." >&2; exit 3; }

regex="$("$here/variants.sh" --regex "$brand")"

common=(--color never --with-filename -i --hidden ${word:+"$word"} -g '!.git/**')
[ -n "$all" ] && common+=(--no-ignore)
[ "${#extra[@]}" -gt 0 ] && common+=("${extra[@]}")

tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT

case "$mode" in
  summary)
    n="$(rg "${common[@]}" -c -e "$regex" "$path" 2>/dev/null | awk -F: '{s+=$NF} END{print s+0}')"
    echo "total matches: $n"
    exit 0 ;;
  files)
    rg "${common[@]}" -l -e "$regex" "$path" 2>/dev/null | sort ;;
  detail)
    rg "${common[@]}" -n -e "$regex" "$path" 2>/dev/null | tee "$tmp"
    echo "--- total: $(wc -l < "$tmp" | tr -d ' ') matching lines ---" ;;
  count)
    rg "${common[@]}" -c -e "$regex" "$path" 2>/dev/null | sort -t: -k2 -rn > "$tmp"
    if [ ! -s "$tmp" ]; then echo "No matches for any variant of: $brand"; exit 0; fi
    total=0
    while IFS=: read -r file n; do total=$((total + n)); done < "$tmp"
    echo "Total matches: $total across $(wc -l < "$tmp" | tr -d ' ') files"
    echo "Variants searched: $(tr '\n' ' ' <<< "$("$here/variants.sh" "$brand")")"
    echo
    echo "## Matches per file"
    cat "$tmp"
    echo
    echo "## Category hints (files / matches)"
    awk -F: '
      function cat(p) {
        if (p ~ /(^|\/)(node_modules|vendor|third_party|\.venv|venv|site-packages)\//) return "third-party/vendored"
        if (p ~ /(^|\/)(dist|build|target|out|\.next|\.nuxt|coverage|\.output)\// || p ~ /\.min\.(js|css)$/) return "generated"
        if (p ~ /(^|\/)(migrations?|alembic)\// || p ~ /schema\.(sql|prisma)$/) return "db/schema/migration"
        if (p ~ /(^|\/)\.env/ || p ~ /\.env\./) return "environment"
        if (p ~ /(^|\/)(Dockerfile|compose|docker-compose|Chart\.yaml|helm|k8s|\.github\/workflows|\.gitlab-ci|Jenkinsfile|terraform)/ || p ~ /\.tf$/) return "docker/deploy/CI"
        if (p ~ /(^|\/)(__tests__|tests?|spec)\// || p ~ /(test|spec)\.[a-z]+$/ || p ~ /_test\.(go|py)$/) return "tests"
        if (p ~ /\.(md|mdx|rst|adoc)$/ || p ~ /(^|\/)(CHANGELOG|CHANGES|RELEASE|HISTORY)/) return "docs/changelog"
        if (p ~ /(package\.json|pyproject\.toml|setup\.py|Cargo\.toml|go\.mod|composer\.json|pom\.xml|build\.gradle|pubspec\.yaml|\.csproj)$/) return "package metadata"
        if (p ~ /lock/) return "lockfile"
        if (p ~ /\.(png|jpe?g|svg|webp|ico|gif|bmp|pdf|fig|sketch)$/) return "assets"
        if (p ~ /\.(json|ya?ml|toml|ini|cfg|conf)$/) return "configuration"
        if (p ~ /\.(ts|tsx|js|jsx|mjs|cjs|py|rs|go|java|kt|php|rb|c|cc|cpp|h|hpp|cs|swift|dart|vue|svelte|astro)$/) return "source code"
        return "other"
      }
      { c = cat($1); files[c]++; m[c] += $NF }
      END { for (k in files) printf "%d\t%d\t%s\n", m[k], files[k], k }
    ' "$tmp" | sort -t$'\t' -k1,1nr -k3,3 | awk -F'\t' '{ printf "%-24s %4d files  %6d matches\n", $3, $2, $1 }'
    echo
    echo "If a file appears here, decide SAFE vs UNSAFE before editing. See references/safety-rules.md."
    ;;
esac
