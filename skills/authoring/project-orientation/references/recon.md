# Recon

The recon pass is read-only. It reports what a repository says about itself so the agent can decide
where to read; it never edits, and its output is a starting point, not a verdict.

## Run it

```bash
bash scripts/orientation-recon.sh            # from anywhere inside the repository
bash scripts/orientation-recon.sh /path/to/repo
```

## Read the output

| Section | What it tells you |
|---|---|
| **Repo** | Branch, HEAD, and whether the working tree is dirty. A dirty tree means the state you are reading is not the committed state. |
| **Project type** | Which manifests exist, so you know the runtime and where dependency and script configuration lives. |
| **Orientation sources** | Which of `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`, and `docs/` exist. These are what you read in step 1. |
| **Decision log** | The candidate source of record. If there is exactly one, it is the authority when sources disagree. If there are several, that is itself worth noting. |
| **Doc links** | Markdown links whose target does not exist. Each is a broken reference (signal 6). Example paths inside syntax tables are not links and are skipped. |
| **Tracked junk** | Files that look like secrets, runtime state, or build output but are committed. Each is worth a look (signal 7); a committed fixture directory is a false positive. |
| **Gate candidates** | Commands that look like gates, from the manifest scripts, the `Makefile`, and the `justfile`. Candidates only — confirm which ones must stay green. |
| **Hotspots** | The largest source files, as a starting point for where a mistake costs most. Size is a proxy, not a verdict. |
| **Progress** | Files that look like a roadmap, with their checkbox counts. Compare the counts against the artifacts on disk before believing them. |

## What it cannot tell you

Recon is heuristic. It finds candidates; it does not judge them.

- It cannot tell a contradiction from a comparison table.
- It cannot tell a forbidden term from a note explaining the ban.
- It cannot tell a stale checkbox from an unfinished task without the artifacts.

Every `[WARN]` is an invitation to read, not a finding. Promote one to a finding only with evidence,
using the format in `references/anomaly-hunt.md`.

## When python3 is absent

Four checks — **Doc links**, **Gate candidates**, **Hotspots**, and **Progress** — need python3. The
script prints a skip notice and continues. Run those by hand, or say in the report that the
mechanical scan was skipped.
