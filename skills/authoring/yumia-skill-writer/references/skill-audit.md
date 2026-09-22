# Skill Audit

Checklist for refining an existing coding-agent skill so it performs in a real pipeline.
Work top-down: correctness first, polish last. Report every change with a reason.

The text-level defects referenced below (no-ops, negation, leading words, sediment, scattered
meaning) are defined in `writing-craft.md`.

## How to run the audit

1. Read the whole skill: `SKILL.md`, every `references/` file, every script.
2. Read the source material the skill is supposed to encode (if available).
3. Score each section below. Record findings as `FILE:LINE — problem — fix`.
4. Apply fixes in the priority order given.
5. Re-run the validator and the trigger test.

**When auditing a skill you did not write, treat validator errors as claims, not verdicts.** The
link check cannot tell a real link from a placeholder, so it false-positives on:

- Links inside fenced code blocks or inline code spans.
- Example and template links that point into the *target* project (`./src/orders/CONTEXT.md` in a
  format template), not into the skill.

Confirm each reported link by opening the file before you change anything.

## Priority 1 — Correctness (fix or the skill is harmful)

- [ ] Commands actually run. Paths exist. Flags are valid for the installed version.
- [ ] No contradictions between sections or between `SKILL.md` and `references/`.
- [ ] No stale version numbers, hostnames, ports, or API shapes.
- [ ] No dead links to files that were renamed or deleted.
- [ ] Credentials are referenced, never hard-coded.
- [ ] Output formats match what downstream steps actually consume.
- [ ] `metadata.version` exists and reflects the current behaviour.

## Priority 2 — Trigger quality (fix or the skill never fires / always fires)

- [ ] Invocation is decided, not accidental: model-invoked (has a description, agent can fire it)
      or user-invoked (`disable-model-invocation: true`).
- [ ] A model-invoked description states the capability concretely and names the triggering
      situations and user phrasings.
- [ ] A model-invoked description carries at least one anti-trigger (when *not* to use).
- [ ] A user-invoked description is a one-line human-facing summary, with trigger lists stripped.
- [ ] The description does not overlap so much with another skill that both fire.
- [ ] The description is ≤1024 chars.
- [ ] If the skill is user-invoked, nothing else tries to call it as if it were model-invoked.

## Priority 3 — Decision sharpness (fix or decisions stay arbitrary)

- [ ] Every branch has an explicit if/then rule.
- [ ] Conflicting signals have a stated tie-breaker.
- [ ] Missing information has a stated default or a stop-and-ask rule.
- [ ] Every step closes on a criterion the agent can check, so done is distinguishable from
      not-done (a `Done when:` line or a checklist). Vague bounds invite premature completion.
- [ ] Success and failure are both defined observably.
- [ ] No "use good judgment", "handle appropriately", "as needed" without a rule.

## Priority 4 — Trim the weird parts

Remove anything that does not serve the pipeline:

- [ ] Filler, restated intros, and motivational padding.
- [ ] Duplicated instructions across files (the same *meaning* in two places).
- [ ] Scattered meaning: one concept fragmented across headings.
- [ ] **No-ops**: lines the model would follow anyway. Delete the whole sentence, not the
      words from it.
- [ ] **Prohibitions that could be phrased positively.** Rewrite as the target behaviour; keep only
      hard guardrails that cannot be phrased positively.
- [ ] Over-explanation of things the model already knows.
- [ ] Sections, scripts, assets, and references that nothing uses (orphans).
- [ ] Copy-paste leftovers from a different skill or project.
- [ ] Formatting noise: giant tables that could be 3 bullets, nested lists five deep.
- [ ] Vague aspirational goals with no action attached.
- [ ] **Sediment**: stale layers kept because removing felt risky.
- [ ] Language drift: instructions written in a language the consuming model handles worse than English.

When removing, keep a one-line reason. If removal changes behavior, flag it for the user.

## Priority 5 — Pipeline fit

- [ ] Steps are in the order they actually happen.
- [ ] Each step has a clear input and output.
- [ ] Failure handling is explicit: stop, retry, or fall back — and which.
- [ ] The skill states what must never happen, even on failure.
- [ ] Handoffs between skills are explicit (who produces what for whom), and name the skill the way
      the harness fires it.
- [ ] Preconditions carry their remediation.
- [ ] The skill is idempotent or says how to resume after a partial run.

## Report template

```markdown
# Skill Audit — <skill-name>

## Summary
<one paragraph: overall state, biggest risks>

## Findings
| Priority | Location | Problem | Fix applied |
|---|---|---|---|
| 1 | SKILL.md:42 | dead path `/old/dir` | updated to `docker/` |
| 3 | SKILL.md:80 | "handle errors well" | replaced with explicit stop rule |
| 4 | references/x.md | unused | removed |

## Removed
- <item> — <reason>

## Behavior changes
- <what changed and why it matters>

## Verification
- Validator: pass/fail
- Trigger test: pass/fail
- Walkthrough: <example used> → <result>
```
