#!/usr/bin/env bash
# orientation-recon — read-only recon of a repository's orientation layer.
#
# Usage:
#   bash scripts/orientation-recon.sh [repo-root]
#
# Prints the orientation sources, the candidate decision log, broken doc links,
# tracked junk, and roadmap checkbox counts. It never writes to the repository.
#
# The output is a set of candidates to read, not a verdict. Every [WARN] is an
# invitation to look; promote one to a finding only with evidence.
# Two checks (Doc links, Progress) use python3 and are skipped when it is absent.

set -uo pipefail

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$ROOT" || exit 1

ok()   { printf '[OK]    %s\n' "$*"; }
warn() { printf '[WARN]  %s\n' "$*"; }
info() { printf '[INFO]  %s\n' "$*"; }
skip() { printf '[SKIP]  %s\n' "$*"; }
hdr()  { printf '\n== %s ==\n' "$*"; }

have_python3() { command -v python3 >/dev/null 2>&1; }

# ---------------------------------------------------------------- repo state
hdr "Repo"
info "root   : $ROOT"
if git rev-parse --git-dir >/dev/null 2>&1; then
  info "branch : $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')"
  info "HEAD   : $(git log --oneline -1 2>/dev/null || echo '-')"
  dirty="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$dirty" = "0" ]; then ok "working tree clean"; else warn "working tree has $dirty uncommitted change(s)"; fi
else
  skip "not a git repository — branch/HEAD/hygiene checks limited"
fi

# ---------------------------------------------------------------- project type
hdr "Project type"
found_manifest=0
for f in package.json pyproject.toml Cargo.toml go.mod Gemfile composer.json build.gradle pom.xml Makefile justfile; do
  if [ -e "$f" ]; then ok "manifest: $f"; found_manifest=1; fi
done
[ "$found_manifest" = "0" ] && info "no common manifest found — runtime unknown, gate commands must be asked"

# ---------------------------------------------------------- orientation files
hdr "Orientation sources"
for f in AGENTS.md CLAUDE.md CONTRIBUTING.md README.md; do
  if [ -e "$f" ]; then ok "$f"; else info "$f — absent"; fi
done
if [ -d docs ]; then
  n="$(find docs -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
  ok "docs/ ($n markdown file(s))"
else
  info "docs/ — absent"
fi
if find docs -maxdepth 2 -type d -iname 'adr*' 2>/dev/null | grep -q .; then
  ok "ADR directory under docs/"
fi

# ---------------------------------------------------------------- decision log
hdr "Decision log (candidate source of record)"
declare -a decisions=()
while IFS= read -r f; do [ -n "$f" ] && decisions+=("$f"); done < <(
  {
    find . -maxdepth 1 -type f -iname '*decision*.md' 2>/dev/null
    find docs -maxdepth 3 -type f \( -iname '*decision*' -o -ipath '*/adr*/*.md' \) 2>/dev/null
  } | sed 's|^\./||' | sort -u
)
if [ "${#decisions[@]}" -eq 0 ]; then
  info "no decision log found — when sources disagree, ask"
elif [ "${#decisions[@]}" -eq 1 ]; then
  ok "source of record: ${decisions[0]}"
else
  warn "multiple decision-log candidates — name which one is authoritative:"
  printf '%s\n' "${decisions[@]}" | sed 's/^/        /'
fi

# ------------------------------------------------------------------ doc links
hdr "Doc links"
if have_python3; then
  python3 - <<'PY'
import glob, os, re

files = sorted(glob.glob('docs/**/*.md', recursive=True))
root_md = [f for f in ('README.md', 'AGENTS.md', 'CLAUDE.md', 'CONTRIBUTING.md') if os.path.exists(f)]
files = sorted(set(files + root_md))

bad = []
for f in files:
    try:
        raw = open(f, encoding='utf-8').read()
    except OSError:
        continue
    txt = re.sub(r'```.*?```', '', raw, flags=re.S)
    txt = re.sub(r'`[^`]*`', '', txt)
    base = os.path.dirname(f) or '.'
    for m in re.finditer(r'\]\(([^)]+)\)', txt):
        t = m.group(1).split('#')[0].strip()
        if not t or t.startswith(('http', 'mailto:')):
            continue
        if not os.path.exists(os.path.normpath(os.path.join(base, t))):
            bad.append(f'{f}: broken link -> {t}')

for b in bad:
    print('[WARN] ', b)
if not bad:
    print('[OK]    no broken markdown links (example paths in fences skipped)')
PY
else
  skip "python3 not found — check doc links by hand"
fi

# --------------------------------------------------------------- tracked junk
hdr "Tracked junk"
if git rev-parse --git-dir >/dev/null 2>&1; then
  junk="$(git ls-files 2>/dev/null | grep -E '^(node_modules/|\.venv/|venv/|dist/|build/|target/)' || true)"
  secrets="$(git ls-files 2>/dev/null | grep -E '(^|/)\.env$|(^|/)\.env\.(local|development|production|test)$|\.pem$|\.key$|(^|/)secrets?/|credentials\.(json|ya?ml|ini)$' || true)"
  if [ -n "$junk" ]; then warn "committed build/dependency dirs:"; printf '%s\n' "$junk" | sed 's/^/        /'; fi
  if [ -n "$secrets" ]; then warn "possible committed secrets:"; printf '%s\n' "$secrets" | sed 's/^/        /'; fi
  [ -z "$junk$secrets" ] && ok "no common junk or secrets tracked"
  info "committed fixture/example dirs are intentional — verify before reporting"
else
  skip "not a git repository — hygiene check skipped"
fi

# ------------------------------------------------------------ gate candidates
hdr "Gate candidates"
if have_python3; then
  python3 - <<'PY'
import json, os, re

gates = []
if os.path.exists('package.json'):
    try:
        scripts = json.load(open('package.json', encoding='utf-8')).get('scripts', {})
        for name in scripts:
            if re.search(r'test|lint|type|check|build|ci', name, re.I):
                gates.append(f'package.json script: {name}')
    except (OSError, json.JSONDecodeError):
        pass
if os.path.exists('Makefile'):
    try:
        for line in open('Makefile', encoding='utf-8'):
            m = re.match(r'^([A-Za-z][A-Za-z0-9_.-]*):', line)
            if m:
                gates.append(f'Makefile target: {m.group(1)}')
    except OSError:
        pass
if os.path.exists('justfile'):
    try:
        for line in open('justfile', encoding='utf-8'):
            m = re.match(r'^([A-Za-z][A-Za-z0-9_-]*)\s*:', line)
            if m:
                gates.append(f'justfile recipe: {m.group(1)}')
    except OSError:
        pass

for g in gates:
    print('[INFO] ', g)
if not gates:
    print('[SKIP]  no gate commands found in a manifest — ask which commands must stay green')
PY
else
  skip "python3 not found — read gate commands from the manifest by hand"
fi

# ------------------------------------------------------------------- hotspots
hdr "Hotspots (largest source files)"
if have_python3; then
  python3 - <<'PY'
import os

EXTS = {'.ts', '.tsx', '.js', '.jsx', '.py', '.go', '.rs', '.java', '.rb', '.c', '.h', '.cpp',
        '.cs', '.php', '.swift', '.kt'}
SKIP_DIRS = {'node_modules', '.git', 'vendor', 'target', 'dist', 'build', '.venv', 'venv',
             '__pycache__', 'coverage', 'tmp', 'var', 'tests', 'test', 'spec', '__tests__'}
TEST_SUFFIX = ('.test.ts', '.test.tsx', '.spec.ts', '.spec.tsx', '_test.go', '_test.py',
               '.test.js', '.spec.js')
TEST_PREFIX = ('test_', 'spec_')

rows = []
for root, dirs, files in os.walk('.'):
    dirs[:] = [d for d in dirs
               if d not in SKIP_DIRS and not d.startswith('.') and not d.endswith('_cache')]
    for f in files:
        if os.path.splitext(f)[1] not in EXTS:
            continue
        if f.endswith(TEST_SUFFIX) or f.startswith(TEST_PREFIX):
            continue
        p = os.path.join(root, f)
        try:
            n = sum(1 for _ in open(p, encoding='utf-8', errors='ignore'))
        except OSError:
            continue
        rows.append((n, p))

rows.sort(reverse=True)
for n, p in rows[:10]:
    print(f'[INFO]  {n:>6}  {p[2:] if p.startswith("./") else p}')
if not rows:
    print('[SKIP]  no source files found — ask where the risky code lives')
PY
else
  skip "python3 not found — list the largest source files by hand"
fi

# -------------------------------------------------------------------- progress
hdr "Progress"
if have_python3; then
  python3 - <<'PY'
import glob, os, re

files = sorted(glob.glob('docs/**/*.md', recursive=True))
for extra in ('ROADMAP.md', 'TODO.md', 'PLAN.md'):
    if os.path.exists(extra):
        files.append(extra)
radar = []
for f in files:
    try:
        t = open(f, encoding='utf-8').read()
    except OSError:
        continue
    boxes = re.findall(r'^\s*-\s+\[[ xX]\]', t, flags=re.M)
    if len(boxes) >= 5:
        done = sum(1 for b in boxes if '[x]' in b.lower() or '[X]' in b)
        radar.append((f, done, len(boxes)))

if not radar:
    print('[INFO]  no roadmap-like document (>=5 checkboxes) found')
else:
    for f, done, total in radar:
        print(f'[INFO]  {f}: {done}/{total} checked')
    print('[INFO]  checkboxes are claims — compare them against artifacts on disk')
PY
else
  skip "python3 not found — count checkboxes by hand"
fi

# ----------------------------------------------------------------------- done
hdr "Done"
info "every [WARN] is a candidate to read, not a finding"
info "report findings per references/anomaly-hunt.md; never decide a locked decision yourself"
