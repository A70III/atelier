# The Orientation Artifact

The layer a repository hands to any agent. Fill every section that applies. Mark anything you cannot
determine `OPEN:` rather than leaving it out or guessing.

Keep it lean. This file loads into an agent's context, so every line pays rent. Depth belongs in the
documents it routes to.

## Where it lives

Follow the project's existing convention first. If the project has one, point at it from
`AGENTS.md` rather than starting a second home.

- **Default for a new layer** — `AGENTS.md` at the repository root, with detail in `docs/`.
- **Existing conventions to look for** — `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`, numbered
  docs (`docs/01-…`), a decision log, `docs/adr/`.

Never keep the same meaning in two places. If the project already documents an invariant, the
orientation artifact points at it; it does not restate it.

## Section by section

Every section earns its place by answering a question the agent would otherwise guess at.

### Mental model

One short paragraph plus the component diagram, if a diagram clarifies the dependency direction.
This is the sentence an agent should be able to repeat back.

*Write:* what the project is, its main parts, and the one flow that matters most.
*Omit:* history, motivation, feature lists.

### Vocabulary

| Term | Meaning here |
|---|---|

Only terms whose project meaning differs from the ordinary one. A term defined here is a leading
word the rest of the layer can use freely.

### Routing

| You are asked to | Read |
|---|---|

The doc-routing table. This is the highest-value section: it is what lets an agent work without
reading the whole repository. Cover every kind of work the project actually has, and make every
target a file that exists.

### Hard invariants

| Never | Because | Do instead |
|---|---|---|

The rules that must survive every change. Write each one as a prohibition, its reason, and the
positive action that replaces it. An invariant with no "do instead" is unusable — it tells the
agent what not to do but not what to do.

### Out of scope

A list of what the project deliberately excludes, each with its reason. This is what stops an agent
from proposing, for the second time, something the project already rejected.

### Decisions of record

Name the single authoritative source, and the rule for when sources disagree (normally: the newer
one wins, and if recency does not settle it, ask). Every other section answers to this one.

### Progress

Where the project records what is done and what comes next, and the artifact that proves it. State
explicitly that progress is judged from artifacts on disk, not from checkboxes — the two drift, and
that drift is itself a finding.

## The profile

The interface other skills read to do their own work. Keep these headings and their bullet format
exact; the content is the project's.

The invariants are not restated here — the **Hard invariants** table above is their single home, and
the profile points at it.

```markdown
## Profile

### invariants
- see the Hard invariants table above

### hotspots
- <path or glob> — <risk> — <symptom>

### gates
- <command> — <what it proves>
```

- **invariants** — a pointer to the Hard invariants table, which stays the single home.
- **hotspots** — the files where a mistake is most costly, what the risk is, and how the mistake
  shows up. This is what a bug-hunting skill reads first.
- **gates** — the commands that must stay green, and what each one proves. This is what a
  refactoring skill checks before and after a change.

## Template

Copy this into the project and fill it. Delete any section that genuinely does not apply, and say
in one line why.

```markdown
# <Project> — Orientation

> <One line: what this repository is.>

## Mental model

<Paragraph. Include the component diagram if the dependency direction is not obvious.>

## Vocabulary

| Term | Meaning here |
|---|---|
| <term> | <meaning> |

## Routing

| You are asked to | Read |
|---|---|
| <kind of work> | `<path>` |

## Hard invariants

| Never | Because | Do instead |
|---|---|---|
| <rule> | <reason> | <action> |

## Out of scope

- <thing> — <why it is out>

## Decisions of record

- Source: `<path>`
- When sources disagree: <rule, or "ask">

## Progress

- Source: `<path>`
- Judged by: <artifact>, not checkboxes

## Profile

### invariants
- see the Hard invariants table above

### hotspots
- <path or glob> — <risk> — <symptom>

### gates
- <command> — <what it proves>
```
