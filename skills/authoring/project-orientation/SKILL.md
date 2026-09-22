---
name: project-orientation
description: Builds and maintains a repository's orientation layer — its mental model, vocabulary, document routing, hard invariants, out-of-scope decisions, and progress artifacts — then uses that layer to catch drift before it becomes a bug. Use when starting work in an unfamiliar repository, returning to a project after time away, asked how the project is structured or what its rules are, asked where it stands, or asked to check it for inconsistencies. Do not use for a one-file change in a repository whose orientation layer you have already loaded in this session, for writing the project's own documentation content, or for generic code questions with no project context.
license: MIT
compatibility: Needs bash. The recon script uses python3 when present and skips its four parsing checks when python3 is absent.
metadata:
  author: a70iii
  version: "1.0.0"
  role: orientation-partner
---

# Project Orientation

You are the agent who orients itself before acting. Work in an unfamiliar repository rarely fails
because the code is hard; it fails because the repository's own rules were never read — the agent
follows its defaults and breaks a decision the project locked long ago.

Core belief: *a repository already knows what it wants. The job is to find its **orientation layer**,
work inside it, and keep it honest against **drift**.*

## When to use

- Starting work in a repository you do not yet hold in context.
- Returning to a project after time away.
- Asked how the project is structured, what its rules are, or where to read for a given task.
- Asked where the project stands, what is done, or what comes next.
- Asked to check a repository for inconsistencies or anomalies.

## Do not use

- A one-file change in a repository whose orientation layer you have already loaded in this session.
- Writing the project's actual documentation content — this skill orients; it does not author.
- Generic code questions with no project context.

## The orientation layer

The **orientation layer** is everything a repository says about itself so an agent can work in it
correctly: the mental model, the vocabulary, the document routing, the hard invariants, what is out
of scope, and where progress is recorded. It is not one file — it is whatever the project already
uses (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`, numbered docs, a decision log,
ADRs). Find it; do not assume its shape.

It also carries a **profile** — invariants, hotspots, and gates in a stable shape — that other
skills read to do their own work without re-deriving the project from scratch.

## Workflow

Run the steps in order. Steps 1–3 and step 5 always run; step 4 runs only when the request is about
state. Step 1 is read-only.

### 1. Recon — read-only

```bash
bash scripts/orientation-recon.sh
```

Run it from anywhere in the repository. Use what it flags as your starting point, then read the
discovered sources in this order: `AGENTS.md` or `CLAUDE.md` → the decision log
(`docs/08-decisions.md`, `docs/adr/`, `DECISIONS.md`) → numbered docs → `README.md` /
`CONTRIBUTING.md` → the manifest.

If a source is unreadable, report its path and carry on with the rest; if no source can be read,
stop and say so. Never reconstruct a source from memory.

**Done when:** every orientation source is named with its role, or you have established that none
exists.

### 2. Model

Extract the layer into a mental model you can state without re-reading the repository:

- **Purpose** — why the project exists, in one or two sentences.
- **Components** — the main parts and the direction dependencies run between them.
- **The pipeline** — the one flow that matters most, as ordered steps.
- **Vocabulary** — every term with a project-specific meaning.
- **Hard invariants** — each as `rule — why — do instead`.
- **Out of scope** — what was deliberately excluded, so it is not proposed again.
- **Routing** — for each kind of work, which document to read.
- **Decisions of record** — the authoritative source when sources disagree.
- **Progress** — where what is done is recorded, and the artifact that proves it.
- **Hotspots** — where a mistake costs most. Take them from the project's own risk notes; when it is
  silent, start from the largest source files the recon lists, or gather them by hand.
- **Gates** — the commands that must stay green, and what each one proves. Take them from the
  manifest scripts, the CI config, and the test config; the recon lists candidates, or gather them by
  hand.

**Done when:** you can restate the mental model without opening a file, every non-obvious term is
defined, every invariant carries its "do instead", and Progress, Hotspots, and Gates each name a
source.

### 3. Load or build

Judge the layer against the coherence test: does it name the mental model, its hard invariants (or
state that there are none), the routing for the main kinds of work, its decision of record, and its
`## Profile`?

- **Coherent** → load it and work inside it. Do not restructure it.
- **Missing only the profile** → add the `## Profile` section from `references/orientation-artifact.md`.
  That completes the interface other skills read; it is not a restructure.
- **Missing or thin otherwise** → propose a scaffold from `references/orientation-artifact.md`. State
  plainly what you could not determine, mark it `OPEN:`, and ask before writing.
- **Scaffold declined** → carry on with the model from step 2, and say plainly that it is unverified
  against a written layer.

**Done when:** the layer is loaded, the missing profile is added, a scaffold is on screen and
approved, or the model is carried forward as unverified.

### 4. Anomaly hunt — only when the request is about state

Run this step when the request is about the project's state or consistency — where it stands, what
is inconsistent, what has drifted. A request to *understand* the project ends at step 3.

Run the **drift** signals in `references/anomaly-hunt.md`.

**Done when:** every signal has been scanned, each finding carries `file:line`, the rule it
violates, and a severity, and every dismissed signal is named as a false positive.

### 5. Report

Report at the depth the request asks for. A narrow question gets the answer and the route; an
orientation request gets the layer and its **profile** — the invariants, hotspots, and gates another
skill needs. When the layer or profile is stated, name the file it lives in so a consuming skill
knows where to look; the profile sits under the `## Profile` heading of that file. If step 4 ran,
report its findings worst-first using the format in `references/anomaly-hunt.md`. End with what is
coherent and what is `OPEN:`.

**Done when:** the report is on screen at the depth the request asked for, the file that holds the
layer is named, no finding was fixed silently, and anything contradicting a decision of record has
been put to the user rather than decided.

## Decision rules

| Condition | Action | Tie-breaker / default |
|---|---|---|
| Two orientation sources disagree | The source with decision authority wins | No clear authority → ask; never pick silently |
| A finding contradicts a decision of record | Report it; do not fix it | The decision of record wins over code |
| No orientation layer exists | Propose a scaffold and state what you could not determine | Ask before writing |
| A term has a project-specific meaning | The project's vocabulary wins | Record the collision |
| The layer exists and is coherent | Load and follow it; do not restructure | Rewrite only when asked |
| Asked where the project stands | Judge from artifacts on disk | A checkbox and an artifact disagree = a finding |
| Asked to author the docs content | Hand it back to the human | This skill orients; it does not author |

## Hard guardrails

- Never invent a fact to fill a gap. Mark it `OPEN:` or ask.
- Stay read-only until the layer is loaded or a scaffold is approved.
- When a decision changes, the layer changes in the same change; treat an updated decision with a
  stale layer as a finding.

## References

- `references/orientation-artifact.md` — the layer template, section by section, plus the profile shape.
- `references/anomaly-hunt.md` — the drift signals, the severity scale, the report format, and the
  false-positive guards. Read before reporting.
- `references/recon.md` — what the recon script reports and how to read it.
- `scripts/orientation-recon.sh` — the read-only recon pass.
