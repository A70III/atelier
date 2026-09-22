# Anomaly Hunt

Drift is a repository disagreeing with itself. Each signal below is a place that disagreement
hides. Scan all of them; report only what the evidence supports.

## The signals

### 1. Source against source

The project's own documents contradict each other — a constant with two values, a different order
of milestones, a field that is mentioned in one doc and absent from another.

- **Violates:** the decisions of record.
- **False-positive guard:** a term used in a comparison table, or inside a section titled with what
  the project excludes, is not a contradiction. Read the surrounding heading.

### 2. Source against code

The code does more, less, or differently than the documents say — a route, a field name, a constant,
a cache key that drifted from its stated form.

- **Violates:** the decision the document recorded.
- **False-positive guard:** a path or value inside a code sample, or a comment describing what is
  forbidden, is not the code doing the thing.

### 3. Schema against example

A schema, a type, or a generated artifact disagrees with the committed examples or fixtures.

- **Violates:** the single source of truth the schema claims to be.
- **False-positive guard:** a deliberately-invalid fixture for a negative test.

### 4. Removed-concept leak

Something the project cut has crept back — as a dependency, a branch, a mention, or a field.

- **Violates:** the out-of-scope list.
- **False-positive guard:** the term is legitimate inside the out-of-scope list itself, a
  comparison, or a note explaining the removal.

### 5. Invariant violation

Code or configuration breaks a rule from the profile — the exact thing the project said must never
happen.

- **Violates:** the hard invariant, by name.
- **False-positive guard:** a comment that names the forbidden thing while forbidding it.

### 6. Broken reference

A link, an import, or a cross-reference points at something that no longer exists.

- **Violates:** correctness of the layer itself.
- **False-positive guard:** example paths and placeholders in syntax tables are not real links.

### 7. Tracked junk

Secrets, runtime state, build output, or dependency directories are committed.

- **Violates:** the repository's hygiene policy.
- **False-positive guard:** a fixture directory that is committed on purpose, such as `examples/`.

### 8. Sequence skip

Work exists for a later stage while an earlier stage is unfinished.

- **Violates:** the stated order of work.
- **False-positive guard:** a spike or an explicit exception recorded as a decision.

### 9. List drift

Two places that list the same things disagree — the commands, the tools, the accepted values, the
changelog entries.

- **Violates:** single source of truth.
- **False-positive guard:** a subset listed on purpose, with a pointer to the full list.

### 10. Version drift

A version named in the documents differs from the lockfile, the manifest, or the installed tool.

- **Violates:** the document's accuracy.
- **False-positive guard:** a version quoted as history, or a range rather than a pin.

## Severity

| Severity | Meaning |
|---|---|
| **BLOCKER** | Using the project as written breaks, or the finding contradicts a decision of record |
| **LIKELY BUG** | Strong evidence, but the failure has not been reproduced |
| **SMELL** | Consistent with a problem without proving one |
| **INFO** | Worth recording; no action implied |

A finding you have not proven is never a BLOCKER. Suspicion is not evidence.

## Report format

One block per finding, worst-first.

```
FINDING: <short name>
SEVERITY: BLOCKER | LIKELY BUG | SMELL | INFO
WHERE: <file>:<line>
CONFLICTS WITH: <the invariant, decision of record, or document>
EVIDENCE: <the command, trace, or quote that proves it>
STATUS: reported | proposed <what to decide>
```

Close the report with the state of the layer: what is coherent, and what is `OPEN:`.

## Rules

- Every finding carries a location and the rule it violates, or it is an `INFO` at best.
- Say what you checked and found clean. A bare pass with no account of the work is not a report.
- `SKILL.md` governs what you do with a finding — what to fix, what to report, what to leave to the
  human. This file governs how you find and describe it.
