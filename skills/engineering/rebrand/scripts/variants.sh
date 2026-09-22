#!/usr/bin/env bash
# Generate naming variants of a brand/product name.
#
# Usage:
#   variants.sh "Kyrin Research OS"          # one variant per line
#   variants.sh --regex "Kyrin Research OS"  # single regex alternation
#   variants.sh --json  "Kyrin Research OS"  # JSON array
#
# Only [A-Za-z0-9_-] is emitted, so variants are regex-safe outside character
# classes. camelCase boundaries in single tokens are split first
# ("KyrinResearchOS" -> "Kyrin Research OS").
set -euo pipefail

mode="lines"
case "${1:-}" in
  --regex) mode="regex"; shift ;;
  --json)  mode="json";  shift ;;
  -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
esac

if [ "$#" -eq 0 ] || [ -z "${1// /}" ]; then
  echo "Usage: variants.sh [--regex|--json] <brand name>" >&2
  exit 2
fi

raw="$*"

# Split into alphanumeric words; break camelCase and digits boundaries.
split_words() {
  printf '%s' "$1" \
    | sed -E 's/([a-z0-9])([A-Z])/\1 \2/g' \
    | sed -E 's/([A-Za-z])([0-9])/\1 \2/g' \
    | sed -E 's/[^A-Za-z0-9]+/ /g' \
    | tr -s ' ' | sed -E 's/^ //; s/ $//'
}

lc()  { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
uc()  { printf '%s' "$1" | tr '[:lower:]' '[:upper:]'; }
cap() { local s f; s="$(lc "$1")"; f="${s:0:1}"; printf '%s%s' "$(uc "$f")" "${s:1}"; }
# Like cap() but preserves existing ALL-CAPS acronyms ("OS" stays "OS").
capA() { local s="$1"; case "$s" in *[a-z]*) cap "$s" ;; *) printf '%s' "$s" ;; esac; }

join() { # join <sep> <transform> [words...]
  local sep="$1" fn="$2" out="" w; shift 2
  for w in "$@"; do out+="$("$fn" "$w")$sep"; done
  printf '%s' "${out%"$sep"}"
}

read -r -a W <<< "$(split_words "$raw")"
[ "${#W[@]}" -gt 0 ] || { echo "No alphanumeric words in input." >&2; exit 2; }

# camelCase = first word lower, rest capitalized
camel="$(lc "${W[0]}")"
for ((i = 1; i < ${#W[@]}; i++)); do camel+="$(cap "${W[i]}")"; done
# acronym-aware camelCase/PascalCase
camelA="$(lc "${W[0]}")"
for ((i = 1; i < ${#W[@]}; i++)); do camelA+="$(capA "${W[i]}")"; done

# Abbreviation from initials
abbr=""; for w in "${W[@]}"; do abbr+="$(uc "${w:0:1}")"; done

variants=()
add() { [ -n "${1:-}" ] || return 0; local v; for v in "${variants[@]:-}"; do [ "$v" = "$1" ] && return 0; done; variants+=("$1"); }

# Full multi-word name
add "$raw"
add "$(join ' ' cap "${W[@]}")"          # Title Case
add "$(join ' ' lc  "${W[@]}")"          # lower with spaces
add "$(join ' ' uc  "${W[@]}")"          # UPPER WITH SPACES
add "$(join '-' lc  "${W[@]}")"          # kebab-case
add "$(join '_' lc  "${W[@]}")"          # snake_case
add "$(join ''  lc  "${W[@]}")"          # spaceless lower
add "$(join ''  cap "${W[@]}")"          # PascalCase (spaceless)
add "$camel"                              # camelCase
add "$(join ''  capA "${W[@]}")"         # PascalCase, acronym-aware
add "$camelA"                             # camelCase, acronym-aware
add "$(join '-' uc  "${W[@]}")"          # KEBAB-UPPER
add "$(join '_' uc  "${W[@]}")"          # UPPER_SNAKE
add "$(join ''  uc  "${W[@]}")"          # SPACELESSUPPER
add "$abbr"                               # ABBR
add "$(lc "$abbr")"                       # abbr

# Base token (first word) variants, e.g. "Kyrin" -> "kyrin"/"KYRIN"/"Kyrin"
if [ "${#W[@]}" -gt 1 ]; then
  add "$(lc "${W[0]}")"
  add "${W[0]}"
  add "$(uc "${W[0]}")"
  add "$(cap "${W[0]}")"
fi

case "$mode" in
  lines) printf '%s\n' "${variants[@]}" ;;
  json)  printf '['; for i in "${!variants[@]}"; do
           [ "$i" -gt 0 ] && printf ', '
           printf '"%s"' "${variants[$i]}"
         done; printf ']\n' ;;
  regex) esc=(); for v in "${variants[@]}"; do
           e="$(printf '%s' "$v" | sed -E 's/[][(){}.+*?^$|\\]/\\&/g')"
           esc+=("${e//-/\\-}")
         done
         ( IFS='|'; printf '(%s)\n' "${esc[*]}" ) ;;
esac
