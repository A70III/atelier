# Interview Guide

How Yumia closes the gap between "I read the document" and "I truly understand what must be built."

## The gap taxonomy

Scan every source for these gap types. Each one you find becomes either a question or a marked assumption.

| Gap type | Ask yourself | Example question |
|---|---|---|
| **Goal** | Why does this exist? What changes if it works? | "What outcome tells us this skill succeeded?" |
| **Scope** | What is in, what is out? | "Should this also handle PDFs, or Markdown only?" |
| **Trigger** | When must it fire? When must it *not*? | "If the user pastes a doc with no request, should it still start?" |
| **Invocation** | Who may fire it: the model, the human, or both? | "Should the agent reach for this on its own, or only when you type its name?" |
| **Actor** | Who or what performs each step? | "Who runs the deploy — the agent or the user?" |
| **Input** | What exactly arrives, in what shape? | "Are these docs always Markdown, or sometimes transcripts?" |
| **Output** | What exactly is produced, in what format? | "One merged file, or one skill per document?" |
| **Flow** | What is the true order of steps? | "Does validation happen before or after the walkthrough?" |
| **Decision** | What rule chooses between options? | "When two skills overlap, which one wins?" |
| **Constraint** | What limits apply? | "Any credentials, rate limits, or offline requirements?" |
| **Vocabulary** | Does a term mean something specific here? | "By 'pipeline' do you mean the n8n flow or the agent flow?" |
| **Failure** | What goes wrong today? What is the symptom? | "What does 'it broke' look like in practice?" |
| **Evidence** | How do we know it worked? | "What would you check to trust the output?" |
| **Done** | How does a step know it finished? | "What tells the agent this step is genuinely complete?" |
| **Edge case** | What is the rare-but-real case? | "What if the source document is empty or half-written?" |

## Interviewing rules

1. **Batch by leverage.** 3–7 questions per turn, ordered by impact. Goal and decisions first.
2. **Recommend a default.** Phrase as "I'll assume X unless you say otherwise" — lowers effort.
3. **Be concrete.** Tie every question to a real example from the source material.
4. **No leading walls.** If answering a question would take a table, it is too big — split it.
5. **Reflect back.** After each batch, restate what changed in the Understanding Brief.
6. **Know when to stop.** When remaining gaps cannot change the skill's behavior, stop asking and
   record them as `ASSUMPTION:` lines in the digest.
7. **Never interrogate the user about things you can verify yourself** by reading a file or
   running a command. Verify, then ask only what remains.

## Question bank (reusable stems)

Pick the ones that fit; do not ask all of them.

**Goal & success**
- What problem does this solve, and for whom?
- What does a successful run produce, concretely?
- How will you judge that the skill is working well a month from now?

**Triggers**
- What exact user phrases or situations should start this?
- What situations look similar but must *not* start it?
- Should it ever run automatically, or only on request?

**Invocation & packaging**
- Should the agent reach for this on its own, or only when the human types its name?
- Does another skill need to call this one?
- Is this one skill, or does it split into two — and along which cut (sequence or invocation)?
- What must already be true before it runs, and what should happen if it is not?

**Inputs & outputs**
- What are all the input shapes, including messy ones?
- What is the exact output format, with a small example?
- Where do inputs come from and where do outputs go?

**Pipeline & decisions**
- Walk me through the real steps in order, as they happen today.
- At each branch, what rule decides the path?
- When two signals conflict, which one wins?

**Constraints & environment**
- What tools, accounts, or credentials are required?
- Any hard limits (rate, size, time, offline)?
- Which OS/runtime must this work on?

**Failure & recovery**
- What is the most common failure today, and its symptom?
- When it fails, should it stop, retry, or fall back?
- What must never happen, even on failure?

**Quality bar**
- What separates a good output from a mediocre one here?
- What would make you reject the output?
- What tells you a step is done, rather than merely under way?

## Understanding Brief template

Produce this at the end of Phase 1 and update it after every interview batch.

```markdown
# Understanding Brief — <topic>

## Request (restated)
<1–3 sentences>

## What I understood
- Purpose: ...
- Actors: ...
- Inputs → Outputs: ...
- Constraints: ...

## Pipeline as I model it
1. ...
2. ...
3. ...

## Vocabulary
| Term | Meaning here |
|---|---|
| ... | ... |

## Gaps to close (prioritized)
1. [Goal] ...
2. [Decision] ...
3. [Edge case] ...

## Working assumptions (unconfirmed)
- ASSUMPTION: ...
```
