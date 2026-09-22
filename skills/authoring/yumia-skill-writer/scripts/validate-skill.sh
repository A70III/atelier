#!/usr/bin/env bash
# Validate a coding-agent skill against the Agent Skills format used by pi.
# Usage: validate-skill.sh <skill-dir> [<skill-dir> ...]
#
# Deliberate limitations of the link check:
#   - Relative links resolve against the skill directory, per pi's "relative paths
#     from the skill directory" convention.
#   - Links inside fenced code blocks and inline code spans are ignored, because
#     those are usually examples or placeholders, not real links.
#   - A file that is a template for another project can opt out of the link check
#     entirely by containing the marker `validate:ignore-links` in an HTML comment.
#   - Skill-internal code spans are checked too, but only under `references/`,
#     `scripts/`, and `assets/`.
set -uo pipefail

errors=0
warnings=0

err()  { printf '  ERROR   %s\n' "$*"; errors=$((errors + 1)); }
warn() { printf '  WARN    %s\n' "$*"; warnings=$((warnings + 1)); }
ok()   { printf '  ok      %s\n' "$*"; }

# Fields pi understands. Anything else is ignored by pi but may be valid for
# another harness (Claude Code uses argument-hint, for example).
PI_FIELDS='^(name|description|license|compatibility|metadata|allowed-tools|disable-model-invocation):'
OTHER_HARNESS_FIELDS='^(argument-hint|arguments|policy|tools|model|user-invocable):'

# Print the relative link targets in one Markdown file, skipping fenced code
# blocks and inline code spans. Returns nothing for an opted-out file.
extract_links() {
  local file="$1"
  if grep -q 'validate:ignore-links' "$file" 2>/dev/null; then
    return 0
  fi
  awk '
    /^[[:space:]]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    { print }
  ' "$file" \
    | sed -E 's/`[^`]*`//g' \
    | grep -oE '\]\([^)]+\)' \
    | sed -E 's/^\]\(//; s/\)$//' \
    | grep -vE '^(https?:|mailto:|#|$)' || true
}

# Print the skill-internal paths referenced from one Markdown file as code spans,
# e.g. `references/api.md` or `scripts/run.sh`. Only the three trees a skill owns are
# checked, so discovery locations (`~/.pi/agent/skills/`), harness files
# (`agents/openai.yaml`), command names (`/skill:name`), and example paths inside other
# projects are never mistaken for broken references. Fenced code blocks are skipped.
extract_code_paths() {
  local file="$1"
  if grep -q 'validate:ignore-links' "$file" 2>/dev/null; then
    return 0
  fi
  awk '
    /^[[:space:]]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    { print }
  ' "$file" \
    | grep -oE '`(references|scripts|assets)/[A-Za-z0-9._/-]+`' \
    | tr -d '`' || true
}

validate_one() {
  local dir="$1"
  local skill="$dir/SKILL.md"

  printf '\n== %s ==\n' "$dir"

  if [ ! -d "$dir" ]; then
    err "directory not found: $dir"
    return
  fi
  if [ ! -f "$skill" ]; then
    err "SKILL.md not found in $dir"
    return
  fi

  # --- frontmatter ---
  local first
  first="$(head -n 1 "$skill")"
  if [ "$first" != "---" ]; then
    err "SKILL.md must start with a '---' frontmatter block"
    return
  fi

  local fm
  fm="$(awk 'NR>1 && /^---[[:space:]]*$/{exit} NR>1{print}' "$skill")"
  if [ -z "$fm" ]; then
    err "empty frontmatter block"
    return
  fi

  # --- invocation mode ---
  local invocation="model"
  if printf '%s\n' "$fm" | grep -qE '^disable-model-invocation:[[:space:]]*true([[:space:]]*#.*)?[[:space:]]*$'; then
    invocation="user"
  fi

  # --- name ---
  local name
  name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n1 | tr -d '"'"'"'' | sed 's/[[:space:]]*$//')"
  if [ -z "$name" ]; then
    err "missing required field: name"
  else
    if [ "${#name}" -gt 64 ]; then
      err "name exceeds 64 chars (${#name})"
    fi
    if ! printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
      err "invalid name '$name' (lowercase a-z0-9, single hyphens, no leading/trailing hyphen)"
    else
      ok "name: $name"
    fi
  fi

  # --- description ---
  local desc
  desc="$(printf '%s\n' "$fm" | sed -n 's/^description:[[:space:]]*//p' | head -n1)"
  if [ -z "$desc" ]; then
    err "missing required field: description (skill will NOT load without it)"
  else
    local dlen=${#desc}
    if [ "$dlen" -gt 1024 ]; then
      err "description exceeds 1024 chars ($dlen)"
    elif [ "$dlen" -lt 40 ]; then
      warn "description is very short ($dlen chars) - may not trigger reliably"
    else
      ok "description: $dlen chars"
    fi
    # A user-invoked skill's description is human-facing: trigger lists are noise.
    if [ "$invocation" = "user" ]; then
      case "$desc" in
        *[Uu]se\ when*|*[Uu]se\ this*|*[Uu]se\ for*)
          warn "user-invoked description carries trigger phrasing; keep it a one-line human-facing summary" ;;
        *)
          ok "description is human-facing (user-invoked)" ;;
      esac
    else
      case "$desc" in
        *[Uu]se\ when*|*[Uu]se\ this*|*[Uu]se\ for*|*[Ww]hen\ *) : ;;
        *) warn "description does not say when to use the skill" ;;
      esac
    fi
  fi

  # --- unknown-field hint ---
  while IFS= read -r line; do
    case "$line" in
      ''|'#'*|' '*|'-'*) continue ;;
    esac
    if ! printf '%s' "$line" | grep -Eq "$PI_FIELDS"; then
      if printf '%s' "$line" | grep -Eq "$OTHER_HARNESS_FIELDS"; then
        warn "frontmatter field '${line%%:*}' is not a pi field (ignored by pi; may be valid for another harness)"
      else
        warn "unknown frontmatter field: ${line%%:*}"
      fi
    fi
  done <<EOF
$fm
EOF

  # --- relative paths resolve: Markdown links and skill-internal code spans ---
  local refs
  refs="$(
    while IFS= read -r md; do
      [ -z "$md" ] && continue
      extract_links "$md"
      extract_code_paths "$md"
    done < <(find "$dir" -type f -name '*.md' 2>/dev/null) | sort -u
  )"
  if [ -n "$refs" ]; then
    while IFS= read -r ref; do
      [ -z "$ref" ] && continue
      local target="${ref%%#*}"
      [ -z "$target" ] && continue
      if [ ! -e "$dir/$target" ]; then
        err "relative path not found: $ref"
      fi
    done <<EOF
$refs
EOF
  fi

  # --- scripts executable ---
  if [ -d "$dir/scripts" ]; then
    while IFS= read -r s; do
      [ -z "$s" ] && continue
      if [ ! -x "$s" ]; then
        warn "script not executable: ${s#"$dir"/}"
      fi
    done <<EOF
$(find "$dir/scripts" -type f 2>/dev/null)
EOF
  fi

  ok "structure checked"
}

if [ "$#" -eq 0 ]; then
  echo "usage: $0 <skill-dir> [<skill-dir> ...]" >&2
  exit 2
fi

for d in "$@"; do
  validate_one "$d"
done

printf '\n----------------------------------------\n'
printf 'errors: %d   warnings: %d\n' "$errors" "$warnings"
[ "$errors" -eq 0 ]
