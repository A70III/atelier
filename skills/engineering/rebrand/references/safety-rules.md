# Rebrand Safety Rules

Treat a rebrand as a **controlled migration**, never a global search-and-replace.
When an occurrence is ambiguous, **flag it for review — do not change it.**

## Never modify

| Target | Why | Instead |
|---|---|---|
| Third-party dependency names (`kyrin-ui-kit` in `package.json`) | The package is published under that name | Keep; note as external dependency |
| Third-party **exported symbols** imported by name (`import { KyrinClient } from "kyrin-ui-kit"`) | The symbol is defined by the package; renaming the binding breaks resolution | Keep the symbol, or alias it: `import { KyrinClient as LumenClient }` |
| `node_modules/`, `vendor/`, `third_party/`, `.venv/`, `site-packages/` | Vendored/installed code | Exclude from edits |
| Generated output (`dist/`, `build/`, `target/`, `out/`, `*.min.js`) | Regenerated from source | Edit source, then rebuild |
| Lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `Cargo.lock`, `poetry.lock`) | Integrity pins; only package manager may rewrite | Run install/update, never hand-edit |
| Applied DB migrations (`migrations/0001_*`, `alembic/versions/*`) | Rewriting breaks migration integrity/history | Add a new migration instead |
| Historical `CHANGELOG.md` / release notes | Old name is intentionally historical | Add a new "renamed to X" entry |
| Cryptographic material (keys, signatures, hashes, salts, certs) | Renaming the label breaks verification | Leave untouched |
| Opaque IDs that merely contain a similar substring | Not branding | Leave untouched |
| User data / fixtures containing real captured data | Data integrity | Leave unless it is clearly a test brand string |
| External API paths, webhook names, wire protocol fields | Backwards compatibility | Keep, or add alias + deprecation path |

## Always verify before changing

- Does this string **identify the product**, or is it a coincidence substring?
- Is this value **published/external** (npm, PyPI, Docker Hub, domain, API)?
  Renaming a published identifier is a breaking change — flag it.
- Is this value **read by an external system** (DB name, bucket, queue, env var)?
  Renaming may require an infrastructure migration — flag it.
- Does changing this **change runtime behavior**? If yes, it is a migration, not a rename.

## Safe to change (typical)

- UI copy, page `<title>`, meta/OpenGraph tags
- README and non-historical docs
- Source identifiers that are purely internal (types, classes, local vars, filenames)
- Internal import paths / path aliases
- Internal env var prefixes **only if** you also update every consumer and deployment config
- Docker service names, image tags, compose project name (if not published)
- CI job names, workflow names
- Test fixtures that assert on the product name
- Textual references to logo/asset filenames (the asset itself is a manual task)

## Classification tags for remaining occurrences

**SAFE / INTENTIONAL**
`historical reference`, `migration compatibility`, `third-party dependency`,
`generated artifact`, `external published identifier`, `opaque ID`.

**UNSAFE / NEEDS REVIEW**
`active source code`, `active UI string`, `active configuration`,
`package metadata`, `deployment config`, `active documentation`, `active URL/domain`.

Never report the rebrand as complete while UNSAFE items remain.
