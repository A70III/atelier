#!/usr/bin/env bash
# Repo reconnaissance for a rebrand: detect stacks, tooling, likely brand
# identifiers, and repository-native validation commands.
#
# Usage: discover.sh [repo-root]   (default: current directory)
set -uo pipefail

root="${1:-.}"
cd "$root" 2>/dev/null || { echo "Cannot enter: $root" >&2; exit 2; }

hr() { printf '%s\n' "------------------------------------------------------------"; }
sec() { printf '\n== %s ==\n' "$1"; }
has() { [ -e "$1" ]; }
hasg() { compgen -G "$1" >/dev/null 2>&1; }

echo "# Rebrand Discovery"
echo "root: $(pwd)"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "git root: $(git rev-parse --show-toplevel)"
  echo "branch:   $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo "tracked:  $(git ls-files | wc -l | tr -d ' ') files"
  echo "dirty:    $(git status --porcelain | wc -l | tr -d ' ') change(s)"
else
  echo "git:      not a git repository"
fi

sec "Detected stacks / tooling"
detect() { [ -e "$1" ] && printf '  %-28s %s\n' "$1" "$2"; }
detect package.json            "Node.js / JavaScript project"
detect pnpm-workspace.yaml     "pnpm workspace (monorepo)"
detect lerna.json              "Lerna monorepo"
detect nx.json                 "Nx monorepo"
detect turbo.json              "Turborepo monorepo"
detect tsconfig.json           "TypeScript"
detect pyproject.toml          "Python (PEP 621 / tooling)"
detect setup.py                "Python (setuptools)"
detect requirements.txt        "Python (pip requirements)"
detect Pipfile                 "Python (Pipenv)"
detect manage.py               "Django"
detect Cargo.toml              "Rust / Cargo"
detect go.mod                  "Go modules"
detect pom.xml                 "Java / Maven"
detect build.gradle            "Java / Gradle"
detect build.gradle.kts        "Kotlin / Gradle"
detect composer.json           "PHP / Composer"
detect Gemfile                 "Ruby / Bundler"
detect pubspec.yaml            "Flutter / Dart"
detect Dockerfile              "Docker"
detect compose.yaml            "Docker Compose"
detect docker-compose.yml      "Docker Compose"
detect Chart.yaml              "Helm chart"
detect next.config.js          "Next.js"
detect next.config.ts          "Next.js"
detect nuxt.config.ts          "Nuxt"
detect vite.config.ts          "Vite"
detect angular.json            "Angular"
detect svelte.config.js        "SvelteKit"
detect astro.config.mjs        "Astro"
detect tauri.conf.json         "Tauri desktop app"
detect electron-builder.yml    "Electron app"
detect serverless.yml          "Serverless Framework"
hasg "*.tf" && printf '  %-28s %s\n' "*.tf" "Terraform"
[ -d ".github/workflows" ] && printf '  %-28s %s\n' ".github/workflows/" "GitHub Actions"
for f in .gitlab-ci.yml Jenkinsfile .circleci/config.yml azure-pipelines.yml; do
  [ -e "$f" ] && printf '  %-28s %s\n' "$f" "CI/CD pipeline"
done
for f in android/app/src/main/AndroidManifest.xml ios/Runner/Info.plist ios/*/Info.plist; do
  [ -e "$f" ] && printf '  %-28s %s\n' "$f" "Mobile app metadata"
done

sec "Package manager"
pm=""
if has pnpm-lock.yaml; then pm="pnpm"; elif has yarn.lock; then pm="yarn"
elif has bun.lockb || has bun.lock; then pm="bun"; elif has package-lock.json; then pm="npm"
elif has package.json; then pm="npm (no lockfile)"; fi
[ -n "$pm" ] && echo "  Node: $pm"
has poetry.lock && echo "  Python: poetry"
has uv.lock && echo "  Python: uv"
has Pipfile.lock && echo "  Python: pipenv"
has Gemfile.lock && echo "  Ruby: bundler"
has Cargo.lock && echo "  Rust: cargo"
has composer.lock && echo "  PHP: composer"

sec "Likely brand identifiers (from manifests)"
# Extract a JSON string field with python3, falling back to grep.
jstr() { # jstr <file> <dotted.key>
  local file="$1" key="$2"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$file" "$key" <<'PY' 2>/dev/null
import json,sys
try:
    d=json.load(open(sys.argv[1],encoding="utf-8"))
except Exception:
    sys.exit(0)
cur=d
for p in sys.argv[2].split("."):
    if isinstance(cur,dict) and p in cur: cur=cur[p]
    else: sys.exit(0)
if isinstance(cur,(str,int,float)): print(cur)
PY
  else
    grep -m1 "\"${key##*.}\"" "$file" | sed -E 's/.*:[[:space:]]*"([^"]*)".*/\1/' 2>/dev/null
  fi
}
gstr() { grep -m1 -E "$1" "$2" 2>/dev/null | sed -E 's/^[^:=]*[:=][[:space:]]*//; s/["'\''#,].*$//; s/[[:space:]]*$//'; }

[ -e package.json ] && printf '  package.json name:      %s\n' "$(jstr package.json name)"
hasg "packages/*/package.json" && { echo "  workspace packages:"; for p in packages/*/package.json apps/*/package.json; do
  [ -e "$p" ] || continue; printf '    %-34s %s\n' "$p" "$(jstr "$p" name)"; done; }
[ -e pyproject.toml ] && printf '  pyproject [project].name:%s\n' " $(gstr '^name[[:space:]]*=' pyproject.toml)"
[ -e Cargo.toml ] && printf '  Cargo package name:     %s\n' "$(gstr '^name[[:space:]]*=' Cargo.toml)"
[ -e go.mod ] && printf '  go module:              %s\n' "$(awk '/^module /{print $2; exit}' go.mod)"
[ -e composer.json ] && printf '  composer name:          %s\n' "$(jstr composer.json name)"
[ -e pubspec.yaml ] && printf '  pubspec name:           %s\n' "$(gstr '^name:' pubspec.yaml)"
[ -e Chart.yaml ] && printf '  Helm chart name:        %s\n' "$(gstr '^name:' Chart.yaml)"
[ -e tauri.conf.json ] && { printf '  tauri productName:      %s\n' "$(jstr tauri.conf.json productName)"; printf '  tauri identifier:       %s\n' "$(jstr tauri.conf.json identifier)"; }
[ -e electron-builder.yml ] && printf '  electron appId:         %s\n' "$(gstr '^appId:' electron-builder.yml)"
[ -e public/manifest.json ] && { printf '  PWA name:               %s\n' "$(jstr public/manifest.json name)"; }
[ -e manifest.json ] && printf '  Web app manifest name:  %s\n' "$(jstr manifest.json name)"
for f in android/app/src/main/AndroidManifest.xml; do
  [ -e "$f" ] && printf '  Android package:        %s\n' "$(grep -oE 'package="[^"]+"' "$f" | head -1 | sed 's/.*="//; s/"//')"
done
for f in ios/Runner/Info.plist ios/*/Info.plist; do
  [ -e "$f" ] && printf '  iOS bundle name:        %s\n' "$(gstr 'CFBundleName' "$f")"
done
[ -e index.html ] && printf '  index.html <title>:     %s\n' "$(grep -oE '<title>[^<]*</title>' index.html | sed -E 's/<\/?title>//g')"
[ -e .env.example ] && printf '  env prefixes:           %s\n' "$(grep -oE '^[A-Z][A-Z0-9_]*' .env.example | sed -E 's/_.*//' | sort -u | tr '\n' ' ')"

sec "Suggested validation commands"
have_script() { # have_script <name>
  [ -e package.json ] || return 1
  local n="$1"
  command -v python3 >/dev/null 2>&1 || return 1
  python3 - package.json "$n" <<'PY' 2>/dev/null
import json,sys
d=json.load(open(sys.argv[1],encoding="utf-8"))
sys.exit(0 if sys.argv[2] in d.get("scripts",{}) else 1)
PY
}
node_run() { case "$pm" in pnpm) echo "pnpm $1" ;; yarn) echo "yarn $1" ;; bun) echo "bun run $1" ;; *) if [ "$1" = test ]; then echo "npm test"; else echo "npm run $1"; fi ;; esac; }
if [ -e package.json ]; then
  for s in lint typecheck type-check check test test:unit build; do
    have_script "$s" && printf '  %-10s %s\n' "$s:" "$(node_run "$s")"
  done
fi
[ -e pyproject.toml ] || [ -e requirements.txt ] && {
  command -v pytest >/dev/null 2>&1 && printf '  %-10s %s\n' "test:" "pytest"
  grep -qE 'ruff' pyproject.toml 2>/dev/null && printf '  %-10s %s\n' "lint:" "ruff check ."
  grep -qE 'mypy' pyproject.toml 2>/dev/null && printf '  %-10s %s\n' "typecheck:" "mypy ."
}
[ -e Cargo.toml ] && { printf '  %-10s %s\n' "test:" "cargo test"
  printf '  %-10s %s\n' "lint:" "cargo clippy --all-targets"
  printf '  %-10s %s\n' "build:" "cargo build"; }
[ -e go.mod ] && { printf '  %-10s %s\n' "test:" "go test ./..."
  printf '  %-10s %s\n' "lint:" "go vet ./..."
  printf '  %-10s %s\n' "build:" "go build ./..."; }
[ -e pom.xml ] && { printf '  %-10s %s\n' "test:" "mvn -q test"
  printf '  %-10s %s\n' "build:" "mvn -q -DskipTests package"; }
{ [ -e build.gradle ] || [ -e build.gradle.kts ] || [ -e gradlew ]; } && {
  printf '  %-10s %s\n' "test:" "./gradlew test"
  printf '  %-10s %s\n' "build:" "./gradlew build"; }
if [ -e Makefile ]; then
  for t in test lint check build; do
    grep -qE "^${t}:" Makefile 2>/dev/null && printf '  %-10s %s\n' "$t:" "make $t"
  done
fi
[ -e Dockerfile ] && printf '  %-10s %s\n' "image:" "docker build -t <name> ."
{ [ -e compose.yaml ] || [ -e docker-compose.yml ]; } && printf '  %-10s %s\n' "compose:" "docker compose build"

sec "Branding asset clues"
find . -maxdepth 4 \
  \( -path ./.git -o -path ./node_modules -o -path ./vendor -o -path ./.venv \) -prune -o \
  -iregex '.*\(logo\|favicon\|icon\|brand\|og-image\|apple-touch\|splash\).*\.\(png\|svg\|jpg\|jpeg\|webp\|ico\|gif\|pdf\|sketch\|fig\)' \
  -print 2>/dev/null | sed 's/^/  /' | head -40
echo
hr
echo "Next: audit with scan.sh (do NOT edit yet)."
