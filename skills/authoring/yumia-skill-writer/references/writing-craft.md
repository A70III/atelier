# Writing Craft

The levers that keep a skill **predictable**: the same *process* on every run, not the same output.
Packaging and frontmatter live in `skill-authoring.md`; the refinement pass lives in
`skill-audit.md`. This file covers the text-level craft both of them assume.

Every rule below is written so it can be applied and checked. Where a rule came from watching a
real skill fail, the rule is stated plainly and the story behind it is left out.

## The context pointer

A **context pointer** is how the agent keeps hold of a name for material that is *not* in context,
along with the condition for going to get it. Three things behave this way: a skill's
`description`, an `AGENTS.md` entry that points at a doc, and a `See references/x.md` line inside a
skill body.

What the agent actually reaches — and how dependably — is settled by how the pointer is **worded**,
not by what it points at. When material the agent must have hides behind a pointer worded too
weakly, you have a **variance bug**: some runs find it, some do not.

**Order of repair:** reword the pointer first; pull the material back in only when rewording has
failed. Inlining is the most expensive fix, which is why it goes last.

Every pointer carries two pieces of information:

1. What the target is.
2. The **branches** that should send the agent to it. A branch is one distinct case the target
   handles, so separate runs leave the pointer along separate paths.

Rules for the text of the pointer itself:

- **The leading word goes in front.** That position is what makes the trigger stick.
- **One trigger per branch.** Two synonyms for a single case mean the same branch listed twice —
  merge them, and keep only the cases that genuinely differ.
- **Drop identity the target already states.** Its first line repeats whatever you put here.

## The two loads

Each line you add is paid for from one of two competing budgets:

| Load | What it costs | Who pays |
|---|---|---|
| **Context load** | Tokens and attention spent on every turn, fired or not: a description, an `AGENTS.md` line | The agent, continuously |
| **Cognitive load** | Knowing what documents exist and which one to reach for | The human, once |

Cognitive load buys human agency, so spend it wherever human judgement is doing work and retire it
where it is not. A user-invoked skill whose
description is empty is the standard trade: nothing on the context budget, one item on the human's.

A pointer buys back its own line and no more: whatever sits behind it stays off the context budget
until it fires. Material that nothing points at costs no context at all — at the price of being
something the human must remember on their own.

## The information hierarchy

Two kinds of content go into a document: **steps** (actions the agent takes, in order) and
**reference** (the definitions, rules and facts the agent consults as needed). Any mixture is legal.
A document of pure steps is a recipe; a document of pure reference is a rule set like this file;
most documents sit somewhere between the two.

Sort every piece by how soon it is needed:

1. **In-file step** — top rung. The work itself, in sequence.
2. **In-file reference** — looked up on demand. A flat set of peers is normal here: a review's whole
   rule set can share one rung, and that is a good shape rather than a warning sign.
3. **Disclosed reference** — moved into another file and reachable through a pointer, which loads it
   only when it fires.

### Progressive disclosure

**Progressive disclosure** keeps the always-loaded file small by moving material downward, out of it
and behind a pointer. Read it as protection for the hierarchy rather than as a way to save tokens.
Disclose too little and the top swells; disclose too much and the agent loses material it needed.
Judging that line is the whole job.

### Branching test

The most reliable test for where a piece belongs. **Inline anything every branch reaches; disclose
anything reached by only some of them.** In a document that has steps, reference left inline when it
should have been disclosed buries the steps, and attention to them turns into a gamble — a variance
problem rather than a mere readability one.

### Co-location

The within-file counterpart. The hierarchy sets how deep a piece goes; co-location sets what belongs
next to it. Gather one concept's definition, its rules and its caveats under a single heading, so
reading any one of them brings the rest along.

Three things look alike and are not:

- **Duplication** — one meaning written in two places. Always a defect (see Pruning).
- **Scattering** — one meaning broken into pieces across several places. Also a defect.
- **Leading word** — one *token* repeated on purpose. A feature (see Leading words).

### Sprawl

A document can be too long even when not one line of it is dead. Excess thins the agent's attention,
and it leaves more lines to keep current. The hierarchy is the cure: push reference out behind
pointers, and cut the document along branch or sequence lines so that no path carries more than it
requires.

## Steps and completion criteria

Close **every step with a completion criterion**: the test that says the step is finished. Two
properties give it force:

- **Clarity** — is the difference between finished and unfinished visible to the agent? A soft
  bound ("understanding reached") leaves room for **premature completion**.
- **Demand** — how much the criterion asks for. "Every changed model accounted for" produces
  thorough work; one that says "list the changes" produces whatever comes. Demand is the source of
  **legwork** — the digging an agent does inside a task, implied by the wording, never written out
  as a step.
  Demand also reaches past steps: "every rule applied" holds a flat block of reference to the same
  bar that "every step done" holds a sequence to, and that is what allows a document of pure
  reference to carry an exhaustiveness bar at all.

A criterion is at its best when it is both **checkable** and **exhaustive**.

### Premature completion

The agent closes a step early because its attention slid from doing the work to being done with it.
Two forces are in play: the **post-completion steps** — work visibly waiting — pull the agent
forward, and the clarity of the criterion holds it back.

The order to defend in:

1. **Tighten the bound.** Cheap and local, and usually enough.
2. **Split the sequence to hide what comes later** — only when the bound genuinely cannot be
   tightened *and* you can watch the rush happening. Hiding only takes effect when a genuine
   context boundary separates them (a transfer between agents, or a dispatch to a subagent); calling
   inline keeps the remaining steps visible, so nothing is hidden.

Write the criterion into the skill as a **Done when:** line, or as a `- [ ]` checklist when the step
carries several conditions.

## Leading words

**Leading words** are short concepts the model already owns from pretraining, and that the agent
carries into each run of the document (_seam_, _tracer bullet_, _frontier_, _tight_, _red_).
Used again and again as a bare token rather than inside sentences, a leading word builds up a
definition that spreads across the document and pins down a wide stretch of behaviour at almost no
cost, because the model supplies the meaning from priors it already holds.

It does two jobs:

- Inside the body, **execution**: each appearance steers the agent toward the same response, and
  inside a flat block of reference it concentrates attention on one family of things to watch for.
- Inside a pointer, **invocation**: a word that also appears in the user's prompts, the docs and the
  codebase gives the agent a shared language that links back to this material, so the pointer fires
  more dependably.

You may coin a word instead, as long as you define it — but a coined word has no priors behind it,
so every bit of its meaning has to be spelled out in tokens that a real word would have handed you
free. **Prefer a word the model already knows.**

Look for passages a leading word can absorb: a three-part phrase written out at several places, a
pointer that spends a whole sentence gesturing at one idea. Any of these can collapse into one
token:

- **_tight_** — for "quick, repeatable, cheap to re-run".
- **_red_** — for "a loop you can actually trust", swapping a soft judgement for an observable
  state.
- **_frontier_** — for "the decisions you can ask about right now".

You gain twice: fewer tokens spent, and a firmer thing for the agent to think with. Assume the
document is still carrying restatements a leading word could absorb, and go hunt for them.

## Negation

**Steering by prohibition backfires.** Naming a behaviour in order to ban it puts the banned
behaviour in view and raises its availability instead of lowering it. A prohibition works as a weak
modifier up against a strongly activated concept, and the concept wins: the ban gets read partly as
permission to do exactly that.

**Prompt the positive.** Say what should happen ("write short comments"), and the unwanted version
never enters the text at all.

Keep a prohibition only when it is a **hard guardrail with no positive phrasing available** ("never
`--abort` a merge"; "never invent a fact to fill a gap"). Even then, give the positive target beside
it, so the agent's attention settles on the action.

## Pruning

### Single source of truth

Each meaning gets exactly one authoritative home, so a behaviour change is made in one place.
Duplication not only costs tokens and upkeep: it also overstates that meaning's rank on the
hierarchy, since the meaning now shows up in more than one spot.

### The environment is authoritative too

Scripts in `package.json`, config files, the folder structure and `--help` output are all lookups
the agent can perform itself. Restating them in a document turns the document into a **cache** — a
duplicate of something the agent could have looked up. Cache only what looking cannot recover: the
convention nobody wrote down, the reason a choice was made, the trap no config file admits to.
Anything the agent can retrieve with one file open or one command run belongs in the environment,
where it cannot drift out of date.

### No-ops

Walk the document sentence by sentence hunting **no-ops**: instructions the model would follow
anyway, paying load for a line that changes nothing.

**How to test one:** would this line change what the model does relative to its default? The test
is **model-relative**, never reader-relative — when two people disagree over a no-op, what they
actually disagree about is the default, and the only way to settle that is to run the document, not
to argue.

A failing sentence gets **cut entirely**. Trimming words out of it only leaves a weaker no-op
behind. The same test grades leading words: one that cannot out-pull the default (_try hard_, for an
agent already trying reasonably hard) counts as a no-op; the remedy is to reach for _relentless_, a
stronger word, rather than a different technique.

### Sediment

Without a pruning habit, a document drifts toward **sediment** — stale layers that survive because
writing more always feels safe while deleting feels risky, until someone has to bore through them to
reach the parts still in use.

So check each line for **relevance**: is it still doing work for this document? Relevance drains
from a line in one of two ways — it never bore on the task at all (sheer exposition, or content that
belonged in a disclosed file), or the world it described moved on. Keeping documents short is the
easiest way to keep them relevant.

## Splitting

When you cut a document in two, both budgets are drawn on, so the cut has to earn its place.

- **By sequence** — cut a sequence of steps at the point where later steps would nudge the agent
  toward hurrying the step it is on. Hiding the later work makes the agent dig deeper into the
  current task. Watch the opposite direction too: merging two sequences puts each step's successors
  on display, which is exactly what invites premature completion.
- **By invocation** — when a distinct leading word should be able to fire a piece by itself, or when
  some other skill needs to call it, pull that piece out into a skill of its own with model
  invocation. That purchase costs a permanently loaded description, so the independent reach must
  justify its price. Mechanics live in `skill-authoring.md`.

## Checklist

Read the body once more and ask:

- [ ] Does every pointer say what the target is and which branches reach it?
- [ ] Is anything every branch needs left out, or anything only some branches need left in?
- [ ] Does each step close on a criterion that is checkable and exhaustive?
- [ ] Is any meaning written twice, or broken up across headings?
- [ ] Is any line a cache over something the agent can look up?
- [ ] Is any line a no-op against the model's default? Cut the sentence, not the words in it.
- [ ] Is any instruction a prohibition that could be stated positively instead?
- [ ] Does every repeated term earn its repetition by working as a leading word?
- [ ] Would a sequence cut or an invocation cut leave both halves stronger?
