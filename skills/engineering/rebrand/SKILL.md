---
name: rebrand
description: Safely rebrands a product across a repository — audits every old-brand occurrence, replaces only the safe ones, and validates the result. Invoke as /skill:rebrand OldName -> NewName.
license: MIT
disable-model-invocation: true
metadata:
  author: a70iii
  version: 1.0.0
---

# Rebrand

Migrate an application's old brand/product identity to a new one across the
entire repository.

**Core principle:** this is a *controlled migration*, not a search-and-replace.
Priorities, in order:

1. Preserve functionality
2. Avoid destructive changes
3. Remove unintended old branding
4. Maintain naming consistency
5. Validate the result

## When to use

Use this for migrating a product or application's brand identity across a
repository: display name, package metadata, source identifiers, config, docs,
tests, deployment, and asset references.

Do not use it for renaming a single variable or symbol, renaming a git branch,
renaming a file, or refactoring unrelated to brand identity.

Read [references/safety-rules.md](references/safety-rules.md) before editing and
use [references/rebrand-manifest.md](references/rebrand-manifest.md) as the audit
template.

## Inputs

Invocation forms (Pi skill command; extra text is passed as arguments):

```text
/skill:rebrand                          # infer names from the repo, ask if unclear
/skill:rebrand OldName -> NewName       # use these directly
/skill:rebrand OldName to NewName       # accept "->", "to", or "=>"
```

If either name cannot be reliably determined, ask exactly:

```text
Old brand:
New brand:
```

Never guess a new brand name. If the old brand is inferable from manifests
(`discover.sh` prints candidates) but the new one is missing, ask only for the
new brand.

Stop and ask when the old and new brand are identical, or when the new brand
contains the old brand as a substring (replacement would cascade).

Resolve the helper scripts against this skill's own directory. pi reports that
path when it loads the skill (`References are relative to <dir>`); set it once:

```bash
RB="<this skill's directory>"   # the absolute path pi reported on load
```

The scripts are read-only. `scan.sh` requires ripgrep (`rg`); if it is missing,
install it (`dnf install ripgrep` on Fedora) or ask the user before continuing.

## Workflow

### 0. Git safety preflight

Never overwrite unrelated uncommitted work. Never reset, never delete unrelated
files, never commit unless explicitly asked.

```bash
git rev-parse --is-inside-work-tree
git status --porcelain
git rev-parse HEAD
```

Record the baseline. If the tree is dirty with changes unrelated to the rebrand,
tell the user and ask whether to continue. If this is not a git repository, say
so and continue without a baseline. Keep the manifest and notes in the
conversation, or a single `.rebrand-manifest.md` file (remove at the end).

**Done when:** the branch, HEAD, and dirty state are recorded, or the absence of
git is stated.

### 1. Discover

```bash
"$RB/scripts/discover.sh" .
```

Inspect languages, frameworks, package managers, monorepos, build systems, CI,
Docker, mobile metadata, docs, likely brand identifiers, and the repo-native
test/lint/typecheck/build commands. Read the output and look at the repo — do
not assume a stack.

**Done when:** the stack, package manager, and repo-native validation commands
are named from the script output.

### 2. Audit before editing

Generate the naming variant matrix and scan:

```bash
"$RB/scripts/variants.sh" "Old Brand Name"
"$RB/scripts/scan.sh" "Old Brand Name" .            # counts + category hints
"$RB/scripts/scan.sh" -d "Old Brand Name" .         # matching lines
"$RB/scripts/scan.sh" -w "Old Brand Name" .         # whole words only
"$RB/scripts/scan.sh" -a "Old Brand Name" .         # include generated/ignored
```

`scan.sh` covers exact, lowercase, uppercase, kebab-case, snake_case,
PascalCase, camelCase, spaceless, abbreviation, and base-token forms. Extend the
search manually for things the generator cannot know:

```bash
# domains, Docker images, env prefixes, app IDs, repo names, package names
"$RB/scripts/scan.sh" -L "oldbrand" .
rg -n -i --hidden -g '!.git/**' 'old[-_.]?brand|old brand' .
```

Also search variants of the name itself when the brand is multi-word
(e.g. `Kyrin Research OS` → `kyrin`, `KRO`).

**Done when:** the variant matrix, the scan counts, and the matching lines are
captured.

### 3. Build the Rebrand Manifest

Use [references/rebrand-manifest.md](references/rebrand-manifest.md). For every
occurrence group record: **old value, new value, category, files affected,
safe?, notes/reasoning**. Categorize into:

product/UI branding · source-code identifiers · package metadata ·
configuration · environment variables · URLs/domains · documentation · tests ·
Docker/deployment · assets · database/schema/migrations · historical records ·
third-party dependencies · generated artifacts.

Apply the safety gate from [references/safety-rules.md](references/safety-rules.md).
Mark anything ambiguous as **review**, not as an edit.

Shared resources (DNS, TLS, published packages, container registries, external
API paths, secret stores, database names) must be flagged — renaming them is an
infrastructure migration, not a text change.

**Done when:** every old→new pair has a category, a file list, and a `safe?`
verdict, with ambiguous pairs marked `review`.

### 4. Apply safe replacements

Rules:

- Replace the **longest / most specific variant first**, then shorter ones.
  Otherwise `kyrin` → `lumen` runs first and turns `kyrin-research-os` into
  `lumen-research-os`.
- Use the per-variant mapping from the manifest, preserving case style:

  | Old | New |
  |---|---|
  | `Kyrin Research OS` | `Lumen` |
  | `kyrin-research-os` | `lumen` |
  | `kyrin_research_os` | `lumen` |
  | `KyrinResearchOS` | `Lumen` |
  | `kyrinResearchOS` | `lumen` |
  | `KYRIN_RESEARCH_OS` | `LUMEN` |
  | `kyrin` | `lumen` |

  Do **not** assume every occurrence transforms this way — follow the manifest.

- Prefer targeted `edit` operations. For large mechanical sets, restrict to an
  explicit allowlist of safe files produced by the audit, e.g.:

  ```bash
  # SAFE_FILES is the reviewed list, one path per line (from the manifest)
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    sed -i "s/<old-variant>/<new-variant>/g" "$f"
  done < SAFE_FILES
  ```

- Update where appropriate: display name, page titles, metadata, README, docs,
  package manifests, source identifiers, imports, app IDs, config, env var names
  (plus every consumer), Docker config, service names, scripts, CI/CD, internal
  URLs, frontend branding, test fixtures, and textual asset references.
- Do not rename symbols imported by name from third-party packages; keep the
  original symbol or alias it (`import { OldClient as NewClient }`). The same
  applies to externally consumed API fields.
- Preserve behavior and architecture. A rename that needs a compatibility alias
  or data migration gets an alias/migration — not a silent break.
- For lockfiles and installed packages, run the package manager
  (`npm install`, `pnpm install`, `cargo update -p <pkg>`, `poetry lock`, ...)
  instead of hand-editing.

**Done when:** every safe pair from the manifest is applied, longest variant
first, and no guarded target was touched.

### 5. Naming normalization

Infer the convention already used by the repo and reuse it for the new name
(see `variants.sh`). Example: `Kyrin Research OS` → `Lumen` normally collapses
to a single token (`lumen`, `LUMEN`, `Lumen`), because the new brand has no
multi-word form. Let repository context and the manifest decide — do not
mechanically apply every transform.

**Done when:** the new forms match the convention the repo already uses.

### 6. Assets

Inspect references to logos, favicon, app icons, manifest/PWA icons, OpenGraph
images, and other branding assets:

```bash
find . -path ./.git -prune -o -path ./node_modules -prune -o \
  -iregex '.*\(logo\|favicon\|icon\|brand\|og-image\).*\.\(png\|svg\|jpg\|jpeg\|webp\|ico\)' -print
```

Update textual references (paths, alt text, manifests). **Do not invent or
generate replacement image assets.** If an asset needs redesign, list it under
**Manual tasks**.

**Done when:** textual asset references are updated and every asset needing
redesign is listed under **Manual tasks**.

### 7. Validate

Re-scan for the old brand and every known variant:

```bash
"$RB/scripts/scan.sh" "Old Brand Name" .
"$RB/scripts/scan.sh" -a "Old Brand Name" .
```

Then run the commands detected in step 1 (use what the repo actually has):

```bash
# Node: pnpm/npm/yarn/bun run lint | typecheck | test | build
# Python: ruff check . | mypy . | pytest
# Rust: cargo clippy --all-targets | cargo test | cargo build
# Go: go vet ./... | go test ./... | go build ./...
# Java: ./gradlew build  |  mvn -q verify
# Docker: docker build . ; docker compose build
```

Validate configuration files where possible (JSON/YAML/TOML parse, app manifest
schema). Inspect the full diff:

```bash
git status
git diff --stat
git diff
```

Target: **old brand occurrences → 0 unintended occurrences.**

**Done when:** the repo-native commands have run and the old-brand re-scan is
reported.

### 8. Classify remaining occurrences

Every remaining hit must be labeled:

- **SAFE / INTENTIONAL** — historical reference, migration compatibility,
  third-party dependency, generated artifact, intentionally-referenced old
  product.
- **UNSAFE / NEEDS REVIEW** — active source, UI, configuration, package
  metadata, deployment, active docs, active URLs.

The rebrand is complete only when no UNSAFE items remain.

**Done when:** every remaining hit carries a SAFE or UNSAFE label.

### 9. Report

Produce exactly this structure:

```markdown
# Rebrand Complete

Old:
<old brand>

New:
<new brand>

Changed:
- X files
- X branding references
- X configuration references
- X documentation references

Validation:
- Tests: PASS/FAIL/N/A
- Lint: PASS/FAIL/N/A
- Typecheck: PASS/FAIL/N/A
- Build: PASS/FAIL/N/A
- Old-brand scan: PASS/FAIL

Remaining references:
- <file>: <reason>
- <file>: <reason>

Manual tasks:
- <task>
```

Also mention: files changed, files intentionally skipped, and whether the
working tree contains unrelated user changes you left untouched. Commit only
when explicitly asked.

**Done when:** every field in the report above is filled.

## Failure handling

- `rg` missing → install it or ask the user; stop before scanning.
- A validation command fails → stop, report the exact command and its output,
  and show `git diff`. The rebrand stays incomplete.
- The tree carries unrelated user changes → report them and ask whether to
  continue.
- Two sources disagree on an occurrence → apply the safety gate: mark it
  `review` and leave it unchanged.

## Hard constraints

The full rules live in [references/safety-rules.md](references/safety-rules.md);
these guardrails hold on every run.

- Audit before editing; edit only files on the reviewed safe list.
- Vendored code, lockfiles, applied migrations, cryptographic values, user data,
  opaque IDs, and external published identifiers stay untouched unless an
  explicit compatibility plan is agreed.
- The rebrand is complete only when no UNSAFE old-brand references remain.
- Use the repo's native tooling (grep/rg/git/package manager) and require no
  specific framework.
- Work for TS/JS, Python, Rust, Go, Java, PHP, common frontend/backend
  frameworks, monorepos, and Docker-based apps.
