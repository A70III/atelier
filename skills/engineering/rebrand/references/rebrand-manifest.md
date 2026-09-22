# Rebrand Manifest Template

Build this **before** editing. One row per occurrence group (group identical
old→new pairs across files). Keep it in the conversation or write it to
`.rebrand-manifest.md` in the repo root and delete it before finishing unless
the user asks to keep it.

```markdown
# Rebrand Manifest

Old: <old brand>
New: <new brand>
Repo: <root>   Branch: <branch>   HEAD: <sha>

## Variant map

| Form | Old | New |
|---|---|---|
| Display | Kyrin Research OS | Lumen |
| lower + spaces | kyrin research os | lumen |
| kebab | kyrin-research-os | lumen |
| snake | kyrin_research_os | lumen |
| Pascal | KyrinResearchOS | Lumen |
| camel | kyrinResearchOS | lumen |
| UPPER_SNAKE | KYRIN_RESEARCH_OS | LUMEN |
| base token | kyrin | lumen |

## Occurrences

| # | Old value | New value | Category | Files | Safe? | Notes |
|---|---|---|---|---|---|---|
| 1 | Kyrin Research OS | Lumen | product/UI | src/app.ts, index.html | yes | display name |
| 2 | kyrin-research-os | lumen | package metadata | package.json | yes | also update lockfile via install |
| 3 | KYRIN_API_URL | LUMEN_API_URL | environment | .env.example, deploy/*.yml | review | must update all consumers + secret store |
| 4 | kyrin-ui-kit | (unchanged) | third-party dep | package.json | no | published package, do not rename |
| 5 | Kyrin Research OS | (unchanged) | historical | CHANGELOG.md | no | historical release note |
| 6 | api.kyrin.io | api.lumen.dev | URL/domain | src/*, docs/* | review | DNS + TLS must exist first |

## Decisions
- <what you will change now>
- <what you will defer and why>
```

## Category checklist (make sure each is considered)

- [ ] product / UI branding
- [ ] source-code identifiers
- [ ] package metadata
- [ ] configuration
- [ ] environment variables
- [ ] URLs / domains
- [ ] documentation
- [ ] tests / fixtures
- [ ] Docker / deployment / CI
- [ ] assets (logos, favicon, icons, OG images, manifest icons)
- [ ] database / schema / migrations
- [ ] historical records (changelog, release notes)
- [ ] third-party dependencies
- [ ] generated artifacts
