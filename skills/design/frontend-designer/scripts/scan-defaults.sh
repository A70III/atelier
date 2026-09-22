#!/usr/bin/env bash
#
# scan-defaults.sh - mechanical pre-flight scan for templated-design signatures.
#
# Finds the countable and greppable members of the defaults list and reports them as
#   file:line - RULE-ID - message
# Countable rules report a total and fire only above their threshold.
#
# Usage:
#   scripts/scan-defaults.sh <path> [--include-docs] [--max N] [--quiet]
#
#   <path>            file or directory to scan
#   --include-docs    also scan .md and .txt (off by default: prose is not user-visible UI)
#   --max N           print at most N hits per rule (default 20)
#   --quiet           print the summary only, not the individual hits
#
# Exit codes:
#   0  clean
#   1  hits found
#   2  usage error, or the target does not exist
#
# Known limits of the pattern set:
#   - DEFAULT-PURPLE matches a list of common hex values and utility classes. It is an
#     allowlist, so an indigo nobody has used before will pass. Read the palette by eye
#     as well as by scan.
#   - DEFAULT-CRAFTPAL is computed rather than listed. It converts every hex in the target
#     to HSL and fires when a warm cream or paper ground and a brass, clay, or oxblood
#     accent appear in the same project. The combination is the tell; either family alone
#     is a colour choice. Thresholds are hue 20-65 with low saturation and high lightness
#     for the ground, and hue 20-65 or 350-360 with mid saturation and mid lightness for
#     the accent. A ground at lightness 87 percent passes, so read the palette by eye too.
#   - DEFAULT-RAWHEX drops hex assigned to a custom property and a meta theme colour,
#     since those are the token definition by definition. Anything else is a hit, so a
#     hex written into a component is still caught.
#
# The scan is advisory per hit and authoritative per rule: every hit is reported so a
# human or the agent can confirm it, but a hit is not automatically a defect. A hit is a
# false positive when the brief asked for that pattern, when the pattern lives in a token
# file rather than in a component, or when it sits in a comment, a docstring, or a test
# fixture rather than in a string a user sees. The scan reads whole files, so it cannot
# tell those apart on its own; confirm each hit by opening the line.
set -uo pipefail

TARGET=""
INCLUDE_DOCS=0
MAX_HITS=20
QUIET=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --include-docs) INCLUDE_DOCS=1 ;;
    --quiet)        QUIET=1 ;;
    --max)          shift; MAX_HITS="${1:-20}" ;;
    -h|--help)      sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)             printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
    *)              if [ -z "$TARGET" ]; then TARGET="$1"; else
                      printf 'unexpected argument: %s\n' "$1" >&2; exit 2
                    fi ;;
  esac
  shift
done

if [ -z "$TARGET" ]; then
  printf 'usage: %s <path> [--include-docs] [--max N] [--quiet]\n' "$0" >&2
  exit 2
fi
if [ ! -e "$TARGET" ]; then
  printf 'target not found: %s\n' "$TARGET" >&2
  exit 2
fi
case "$MAX_HITS" in ''|*[!0-9]*) printf -- '--max needs a number\n' >&2; exit 2 ;; esac

# ---------------------------------------------------------------- file selection

if [ -f "$TARGET" ]; then
  FILELIST="$(mktemp)"
  printf '%s\0' "$TARGET" > "$FILELIST"
else
  FILELIST="$(mktemp)"
  EXTRA_ARGS=()
  if [ "$INCLUDE_DOCS" -eq 1 ]; then
    EXTRA_ARGS=( -o -name '*.md' -o -name '*.txt' )
  fi
  find "$TARGET" \
    \( -name node_modules -o -name .git -o -name dist -o -name build -o -name out \
       -o -name .next -o -name .nuxt -o -name .svelte-kit -o -name .output \
       -o -name coverage -o -name vendor -o -name .venv -o -name __pycache__ \
       -o -name '*.min.*' -o -name '*.lock' \) -prune -o \
    -type f -size -512k \
    \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' \
       -o -name '*.mjs' -o -name '*.cjs' -o -name '*.vue' -o -name '*.svelte' \
       -o -name '*.astro' -o -name '*.html' -o -name '*.htm' -o -name '*.css' \
       -o -name '*.scss' -o -name '*.sass' -o -name '*.less' -o -name '*.mdx' \
       "${EXTRA_ARGS[@]}" \) -print0 > "$FILELIST"
fi

FILE_COUNT="$(tr -cd '\0' < "$FILELIST" | wc -c)"
trap 'rm -f "$FILELIST"' EXIT

# ---------------------------------------------------------------- rule table
# RULE-ID <TAB> message <TAB> threshold <TAB> ERE pattern <TAB> optional exclude ERE
# A hit whose line matches the exclude pattern is dropped before counting. Use it only
# for shapes that are correct by definition, such as a hex assigned to a custom
# property, so the rule keeps its teeth where it matters.
# threshold 0 means "any hit fires"; a higher number means "fire above this count".

RULES="$(mktemp)"
trap 'rm -f "$FILELIST" "$RULES"' EXIT
cat > "$RULES" <<'RULEEOF'
DEFAULT-EMDASH	em dash or separator en dash in a user-visible string	0	—|–
DEFAULT-PURPLE	blue-violet, indigo, or purple accent, gradient, or glow	0	#(8b5cf6|7c3aed|a855f7|6366f1|818cf8|6d28d9|9333ea|c026d3|4f46e5|4338ca|1a1a2e|16213e|0f3460|1e1b4b|312e81|3730a3)\b|(from|via|to)-(purple|violet|indigo|fuchsia)-[0-9]{2,3}
DEFAULT-GLOW	glow or coloured halo	0	drop-shadow-\[0_0_|text-shadow:|shadow-\[0_0_[0-9]
DEFAULT-GRADTEXT	gradient-clipped display text	0	bg-clip-text|text-transparent
DEFAULT-PUREBW	pure black or pure white	0	#000000|#000\b|#ffffff|#fff\b
DEFAULT-INTER	over-familiar UI sans or system stack reached for by habit	0	([Ff]ont-?[Ff]amily|--font-[a-z-]+)[^;]*\b(Inter|Roboto|Arial|Helvetica)\b
DEFAULT-SERIFDEFAULT	most-defaulted display serif	0	Fraunces|Instrument_Serif|Instrument Serif
DEFAULT-LUCIDE	defaulted icon set	0	[Ll]ucide
DEFAULT-HSCREEN	static viewport height unit	0	(^|[^a-z-])h-screen|[^a-z-]100vh
DEFAULT-SCROLLLISTENER	scroll listener or scroll position in component state	0	addEventListener\(["']scroll|window\.scrollY|onScroll=
DEFAULT-USESTATEINPUT	pointer or scroll value held in React state	0	useState\([^)]*(scrollY|scrollProgress|mouseX|mouseY|clientX|clientY|pointerX|pointerY)
DEFAULT-LAYOUTANIM	transition on all properties	0	transition-all|transition:\s*all
DEFAULT-GRADIENT	gradient fills used repeatedly	6	gradient
DEFAULT-EYEBROW	small uppercase tracked label above a heading	0	uppercase.*tracking-\[|tracking-\[[0-9.]+em\].*uppercase
DEFAULT-MIDDLEDOT	middle-dot metadata chain	0	·.*·
DEFAULT-NUMBERED	stage, step, phase, or index label	0	\b(Stage|Step|Phase|Pass) [0-9]|No\. [0-9]|[0-9]{2} / [A-Z]{3,}
DEFAULT-SCROLLCUE	scroll prompt	0	Scroll to (explore|see|discover|read|walk)|↓ ?[Ss]croll
DEFAULT-VERSIONLABEL	version or availability stamp as page chrome	0	\b[Bb]eta\b|\b[Ii]nvite-only\b|\b[Ee]arly [Aa]ccess\b|\b[Ii]nternal [Pp]review\b|\b[vV][0-9]+\.[0-9]+
DEFAULT-JANEDOE	placeholder person	0	(John|Jane|Sarah|Jack) (Doe|Chan|Su|Smith)
DEFAULT-SLOPNAME	generator-sounding brand name	0	\b(Acme|Nexus|SmartFlow|Cloudly|Synergy|Foobar)\b
DEFAULT-SLOPVERB	filler marketing verb	0	\b(Elevate|Elevating|Seamless|Seamlessly|Unleash|Next-Gen|Revolutioniz|Game-chang|Cutting-edge)\b
DEFAULT-LOREM	placeholder prose shipped as content	0	[Ll]orem ipsum
DEFAULT-EMOJI	emoji used as a structural icon	0	🚀|✨|🎨|⚙️|🔥|📊|📈|💡|🎯|⚡|🔒|👋|🌟
DEFAULT-ZSPAM	arbitrary z-index values	3	z-\[?[0-9]{2,4}\]?
DEFAULT-RAWHEX	hard-coded hex values outside a token definition	1	#[0-9a-fA-F]{6}\b	(^|[{;[:space:]])--[a-z0-9-]+[[:space:]]*:|theme-color
RULEEOF

# ---------------------------------------------------------------- scan

TOTAL_HITS=0
TOTAL_RULES=0

printf '\nscan-defaults: %s (%s files)\n' "$TARGET" "$FILE_COUNT"

while IFS=$'\t' read -r rule message threshold pattern exclude; do
  [ -z "${rule:-}" ] && continue

  raw="$(xargs -0 -r -a "$FILELIST" grep -nHEI -- "$pattern" 2>/dev/null || true)"
  if [ -n "${exclude:-}" ] && [ -n "$raw" ]; then
    raw="$(printf '%s\\n' "$raw" | grep -vE -- "$exclude" || true)"
  fi
  if [ -z "$raw" ]; then continue; fi

  lines="$(printf '%s\n' "$raw" | grep -c . )"
  count="$(printf '%s\n' "$raw" | grep -oE -- "$pattern" | grep -c . )"
  if [ "$threshold" -gt 0 ] && [ "$count" -le "$threshold" ]; then
    continue
  fi

  TOTAL_HITS=$((TOTAL_HITS + count))
  TOTAL_RULES=$((TOTAL_RULES + 1))

  if [ "$threshold" -gt 0 ]; then
    printf '\n%s  %s (%s hits, threshold %s)\n' "$rule" "$message" "$count" "$threshold"
  else
    printf '\n%s  %s (%s hits)\n' "$rule" "$message" "$count"
  fi

  if [ "$QUIET" -eq 0 ]; then
    printf '%s\n' "$raw" | head -n "$MAX_HITS" | while IFS= read -r line; do
      printf '  %s\n' "$line"
    done
    if [ "$lines" -gt "$MAX_HITS" ]; then
      printf '  ... and %s more\n' "$((lines - MAX_HITS))"
    fi
  fi
done < "$RULES"

# ------------------------------------------------- palette family test (computed)

if [ "$FILE_COUNT" -gt 0 ]; then
  PAL_HEXES="$(xargs -0 -r -a "$FILELIST" grep -ohEI '#[0-9a-fA-F]{6}\b' 2>/dev/null \
    | tr 'A-F' 'a-f' | sort -u || true)"
  if [ -n "$PAL_HEXES" ]; then
    PAL="$(printf '%s\n' "$PAL_HEXES" | awk '
      function hv(c) { return index("0123456789abcdef", c) - 1 }
      function by(h, i) { return hv(substr(h, i, 1)) * 16 + hv(substr(h, i + 1, 1)) }
      function clas(h,   r, g, b, mx, mn, d, l, s, hh, warm) {
        r = by(h, 2) / 255; g = by(h, 4) / 255; b = by(h, 6) / 255
        mx = r; if (g > mx) mx = g; if (b > mx) mx = b
        mn = r; if (g < mn) mn = g; if (b < mn) mn = b
        d = mx - mn
        l = (mx + mn) / 2
        s = (d == 0) ? 0 : d / (1 - ((l > 0.5) ? 2 * l - 1 : 1 - 2 * l))
        if (d == 0) hh = 0
        else if (mx == r) hh = 60 * (((g - b) / d) % 6)
        else if (mx == g) hh = 60 * (((b - r) / d) + 2)
        else hh = 60 * (((r - g) / d) + 4)
        if (hh < 0) hh += 360
        s *= 100; l *= 100
        warm = (hh >= 20 && hh <= 65)
        if (warm && s <= 35 && l >= 88) return "ground " h
        if ((warm || hh >= 350) && s >= 25 && l >= 25 && l <= 65) return "accent " h
        return ""
      }
      { v = clas($0); if (v != "") print v }
    ')"
    GROUND="$(printf '%s\n' "$PAL" | awk '$1 == "ground" { print $2 }')"
    ACCENT="$(printf '%s\n' "$PAL" | awk '$1 == "accent" { print $2 }')"
    if [ -n "$GROUND" ] && [ -n "$ACCENT" ]; then
      G_N="$(printf '%s\n' "$GROUND" | grep -c .)"
      A_N="$(printf '%s\n' "$ACCENT" | grep -c .)"
      TOTAL_RULES=$((TOTAL_RULES + 1))
      TOTAL_HITS=$((TOTAL_HITS + G_N + A_N))
      printf '\nDEFAULT-CRAFTPAL  warm cream or paper ground together with a brass, clay, or oxblood accent\n'
      printf '  ground (%s): %s\n' "$G_N" "$(printf '%s' "$GROUND" | tr '\n' ' ')"
      printf '  accent (%s): %s\n' "$A_N" "$(printf '%s' "$ACCENT" | tr '\n' ' ')"
    fi
  fi
fi

printf '\n----------------------------------------\n'
if [ "$TOTAL_RULES" -eq 0 ]; then
  printf 'scan-defaults: clean. 0 rules fired across %s files.\n\n' "$FILE_COUNT"
  exit 0
fi

printf 'scan-defaults: %s hits across %s rules.\n' "$TOTAL_HITS" "$TOTAL_RULES"
printf 'Confirm each hit against the brief before changing it. Report confirmed false positives.\n\n'
exit 1
