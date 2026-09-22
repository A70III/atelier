# Skill Authoring

Reference for emitting a skill a coding agent can actually load and follow. Based on the Agent
Skills standard as implemented by pi, with the harness-specific notes called out where they differ.

Text-level craft (pointers, loads, hierarchy, completion criteria, leading words, negation,
pruning, splitting) lives in `writing-craft.md`. Read both before authoring.

## Where skills live

- Global: `~/.pi/agent/skills/`, `~/.agents/skills/`
- Project (after trust): `.pi/skills/`, `.agents/skills/`
- Also loadable via packages, settings `skills` array, or `--skill <path>`

Discovery: a directory containing `SKILL.md` is a skill. In `~/.pi/agent/skills/` and
`.pi/skills/`, direct root `.md` files with valid skill frontmatter are also skills.

## Package structure

```
my-skill/
├── SKILL.md              # required: frontmatter + lean instructions
├── references/           # depth loaded on demand
│   └── api-reference.md
├── scripts/              # deterministic helpers
│   └── run.sh
└── assets/               # templates, fixtures
```

Keep `SKILL.md` lean. Everything always in context is a cost; push detail into `references/`
and link with relative paths. See the information hierarchy in `writing-craft.md`.

## Frontmatter

| Field | Required | Rules |
|---|---|---|
| `name` | yes | 1–64 chars, `a-z0-9-`, no leading/trailing hyphen, no `--` |
| `description` | yes | ≤1024 chars. What it does **and when to use it**. |
| `license` | no | name or reference to bundled file |
| `compatibility` | no | ≤500 chars, environment requirements |
| `metadata` | no | arbitrary key/value map (use it for `author`, `version`, `role`, `credits`) |
| `allowed-tools` | no | space-delimited pre-approved tools (experimental) |
| `disable-model-invocation` | no | `true` hides it from the system prompt; human-only via `/skill:<name>` |

pi is lenient: most violations warn but still load. A missing description means **not loaded**.
Name does not have to match the parent directory in pi.

**Cross-harness fields.** Other harnesses add their own keys. Claude Code uses `argument-hint`;
Codex reads `agents/openai.yaml` beside the `SKILL.md`. pi **ignores unknown fields**, so a shared
skill can carry them safely, but do not rely on them firing in pi. When a skill is meant for one
harness, say so in `compatibility`.

## Invocation

One decision splits the whole field, and it changes what the description is for. Make it on purpose.

- **Model-invoked** — leave `disable-model-invocation` out. The `description` now sits in context
  permanently, which turns it into the top-level pointer the agent holds for this skill: you buy
  discoverability with an always-loaded line. The agent may arrive here unaided, and other skills
  may call in. Author the description for the model: trigger branches plus any anti-trigger.
- **User-invoked** — the system prompt no longer carries it, which takes
  `disable-model-invocation: true`. Only a human typing `/skill:<name>` can reach it. Nothing is
  spent on context load. The `description` turns **human-facing** instead: a single summary line for
  someone browsing, with the trigger lists removed.

**The test:** is there a situation where the agent would usefully arrive here unaided, or where
some other skill has to call in? If so, model-invoke. If the skill ever fires only because a human
typed its name, then user-invoke it and spend nothing on context load.

Two failure modes to watch:

- **Over-triggering** — a model-invoked description so broad it fires on neighbouring work. Fix by
  narrowing the trigger branches and adding an anti-trigger.
- **Never firing** — a description that names a theme ("helps with docs") instead of the concrete
  capability and its trigger situations.

In pi, skills also register as `/skill:name` commands, and arguments after the command are appended
to the skill content as `User: <args>`. That is pi's analogue of Claude Code's `argument-hint`.

## Description craft

The description is the trigger. Write it as: **capability + when to use + anti-trigger**.

Good:
```
Extracts text and tables from PDF files, fills forms, and merges PDFs. Use when working
with PDF documents. Do not use for plain-text files.
```

Bad:
```
Helps with PDFs.
```

Checklist:
- [ ] States the concrete capability, not a vague theme.
- [ ] Names the situations that should trigger it (including user phrasings).
- [ ] Distinguishes itself from nearby skills.
- [ ] Carries an anti-trigger when a plausible wrong fire exists.
- [ ] ≤1024 chars.
- [ ] Contains no marketing language.
- [ ] For a user-invoked skill: trigger lists stripped, one-line summary only.

## Body craft

- Start with the role and the one belief that drives behavior.
- Add a **When to use** section mirroring the description, plus a **Do not use** list.
- Give a numbered workflow with explicit decision points.
- **Close each step with a completion criterion** (a `Done when:` line, or a `- [ ]` checklist).
- State **non-negotiable principles** — short, testable rules.
- Add **hard guardrails** — the few prohibitions you cannot phrase positively.
- Use relative paths from the skill directory for scripts and references.
- Write imperative, second person (not "you might consider").
- Prefer a table or list wherever the reader is choosing between branches.

## Decision rules

Vague guidance is the main cause of unreliable skills. Convert every judgment call into a rule:

| Vague | Sharp |
|---|---|
| "Handle errors gracefully." | "On a missing file, stop and report the path; never invent content." |
| "Use good judgment on scope." | "If the doc exceeds 10 sections, split into per-section skills; otherwise one skill." |
| "Prefer the better source." | "When two sources conflict, the newer file wins; record the loser in the digest." |

Include a tie-breaker for conflicting signals, and a default for missing information.

## Splitting and routers

The full test for splitting lives in `writing-craft.md`. What changes with invocation:

- **Split by invocation** when a distinct leading word ought to fire the piece by itself, or when
  some other skill has to reach it. The new skill carries an always-loaded description, and that is
  context load you now pay for good, so the independent reach has to justify the cost.

A thin **wrapper** skill can pass the work to a shared primitive ("Call the skill `grilling`").
Keep the wrapper to the delegation and nothing else; the rules stay in the primitive. That is how
one implementation can serve several entry points without a second copy of the text.

**Router skill.** Once user-invoked skills outnumber what a human can keep in mind, that
accumulation of cognitive load is answered by a single user-invoked **router**: one skill that
lists the others and says which to use when. It points; it cannot fire anything, because a
user-invoked skill carries no description. Treat the router as part of the change: whenever a skill gets
added, renamed, or refitted, update the router, or it starts misleading people.

## Dependencies and preconditions

When a skill has to call another:

- **Name the skill in the step** ("Call the skill `api-conventions` for the vocabulary"). A bare
  `/name` dropped into prose leaves the model guessing; the name is what causes the call.
- **One skill per call.** Two skills needed means two calls; write that down.
- **A user-invoked skill is out of reach for other skills.** Where a step depends on one, address
  the human instead ("point the user at `/skill:setup-thing`").
- **Give every precondition its way out** ("The tracker should already be configured. If it is not,
  have the user run `/skill:setup-...`"). A dead end with no remedy blocks the run.
- **Shared reference belongs to the skill that owns it.** Another skill gets at it by calling that
  skill, not by reaching sideways into its folder.

## Versioning

- Set `metadata.version` on every skill you emit.
- **Bump it on every behaviour change**, not on typo fixes.
- Record the reason for the bump in the session's verification report (Phase 5), or in the repo's
  changelog convention when the target repo has one.
- Use `metadata.credits` when material was adapted from another skill, with author and source URL.

## Scripts

Add a script only when it makes a step **deterministic and repeatable**. A script should:
- Have a shebang, be executable, and take arguments (no interactive prompts).
- Print clear output and use non-zero exit codes on failure.
- Be safe to run twice (idempotent); where a step cannot be, make it fail loudly rather than
  half-apply.
- Be referenced from `SKILL.md` with a relative path and a usage line.

## Pre-ship checklist

- [ ] `name` valid per rules.
- [ ] `description` specific, ≤1024 chars, includes the trigger plus an anti-trigger where a
      plausible wrong fire exists.
- [ ] Invocation decided and consistent with the description's job.
- [ ] Body has a clear workflow, a completion criterion per step, and explicit decision rules.
- [ ] All relative paths resolve.
- [ ] No contradictions between `SKILL.md` and `references/`.
- [ ] No stale versions, dead links, or orphaned files.
- [ ] The craft checklist in `writing-craft.md` passes.
- [ ] Validator passes: `scripts/validate-skill.sh <skill-dir>`.
- [ ] Trigger test passes: reading only the description, the fire/no-fire decision is correct.
