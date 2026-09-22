# Answer Digest Template

The single contract for everything Yumia builds. Fill every section. Mark unknowns as
`ASSUMPTION:` or `OPEN:` — never leave them silently blank.

```markdown
# Answer Digest — <topic>

Status: draft | approved
Date: <YYYY-MM-DD>
Approved: <YYYY-MM-DD>
Target agent/harness: <pi | Claude Code | Codex | other>
Deliverable: <new skill | refine existing skill(s) | both>

## 1. Objective
<What this skill exists to achieve, stated briefly.>

## 2. Success criteria
- <Observable outcome 1>
- <Observable outcome 2>

## 3. Triggers and anti-triggers
**Must fire when:**
- <situation / user phrasing>

**Must NOT fire when:**
- <situation>

## 4. Invocation and package shape
- Invocation: <model-invoked | user-invoked> — <why>
- Shape: <one skill | split by sequence | split by invocation | wrapper + primitive>
- Dependencies: <skills this one calls, or none>
- Preconditions: <what must already be true, and the remediation if it is not>

## 5. Inputs
| Input | Shape | Source | Notes |
|---|---|---|---|
| | | | |

## 6. Outputs
| Output | Format | Destination | Example |
|---|---|---|---|
| | | | |

## 7. Pipeline (ordered)
Each step carries the condition under which the agent knows it is finished.
1. <step> → input: <...>, output: <...>, done when: <criterion>
2. <step> → done when: <criterion>
3. ...

## 8. Decision rules
| Condition | Action | Tie-breaker / default |
|---|---|---|
| | | |

## 9. Constraints
- Environment: <OS, runtime, tools, credentials>
- Limits: <rate, size, time, offline>
- Policies: <what must never happen>

## 10. Failure handling
| Failure | Symptom | Response (stop/retry/fallback) |
|---|---|---|
| | | |

## 11. Quality bar
- Good output looks like: ...
- Reject output when: ...

## 12. Assumptions (unconfirmed)
- ASSUMPTION: ...

## 13. Open questions
- OPEN: ...

## 14. Rejected framings
- <approach considered and deliberately not taken> — <why>

## 15. Out of scope
- ...
```

## Rules for the digest

- One digest per deliverable. If scope splits, split the digest.
- No prose padding — this is a spec, not an essay.
- Every decision rule must be testable by reading a concrete example.
- Every pipeline step needs a completion criterion, or it invites premature completion.
- Record what you rejected, not only what you chose; it stops the same ground being re-argued.
- Get explicit user approval before Phase 4. Record the approval date.
