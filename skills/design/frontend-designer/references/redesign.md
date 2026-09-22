# Redesign Protocol

Most redesign work goes wrong before a single pixel changes, because the wrong job was chosen. A
redesign is not a greenfield build with the old site thrown away: on a surface that already exists,
most of the value is in what survives, and the risk is concentrated in what does not.

## Detect the mode first

**`RD-MODE`** Name the mode before anything else.

- **Greenfield.** There is no existing surface, or an overhaul has already been agreed. The magnitude default comes from `design-direction.md`.
- **Preserve.** The identity stays and the visuals move. Audit first, lift the brand's own tokens, and change things in steps.
- **Overhaul.** A new visual language goes over content that stays. Treat the visuals as greenfield, and treat the content and the page structure as fixed.
- **Review.** Nothing is being changed. Work `review-mode.md` instead.

**`RD-ASK`** When the intent is unclear, ask once: "Keeping the existing brand, or rebuilding the
look from zero?" Nothing else is worth asking until that is settled.

## Audit before touching anything

**`RD-AUDIT`** The audit answers three questions, and all three are answered before any proposal:
what has to survive, what is costing the reader something, and what has to be measurable afterwards.

**What has to survive.** The identity, and the things a returning reader depends on.

- The brand's own tokens: its colours, its type, its mark, its corner treatment, any spacing scale it documents.
- The structure: the page tree, the navigation labels, the paths that lead to a purchase or a submission.
- The voice of the copy, and the interactions people already know how to use.

**What is costing the reader something.** The parts that fail today, judged by looking at the real
thing and by the catalogue in `defaults.md`, not by taste.

- Sections that exist to fill space, and stock photography that says nothing about the subject.
- Broken layouts, dead ends, and anything slow enough to be felt.
- Accessibility that regressed: a focus state that vanished, a target that shrank, contrast that dropped.

**What has to be measurable afterwards.** The baseline, recorded now because it cannot be recovered
later.

- Which pages get found, under which titles and descriptions.
- What the share cards show, and whether the structured data is right.
- The measurements the team already trusts. Renaming a button, a field, or a section id breaks whatever is watching it, so those names are recorded as frozen before work starts.

**`RD-NOAUDIT-NOCHANGE`** No proposal before the audit. Where the code or the live site cannot be
reached, say so and stop rather than guessing at the current state.

## What is frozen

**`RD-IA`** The information architecture does not move unless it was asked to. URL slugs, anchor
identifiers, and the labels in the primary navigation stay where they are, for search and for the
reader's own memory of the site.

**`RD-FROZEN`** These move only with explicit approval, and never silently:

- URL structure and route slugs.
- The labels in the primary navigation.
- Form field names, and the order of the fields.
- The mark and the wordmark.
- Legal, consent, and cookie copy.

**`RD-ANALYTICS`** Existing tracking is respected. Button labels, field names, section identifiers,
and event hooks that downstream measurement depends on are not renamed as a side effect of a restyle.

**`RD-BRAND`** The brand's colours are read out of the existing surface before any palette is chosen.
An identity that already exists is not replaced by a preference: it is executed better. The families
in `defaults.md` are defaults, and a default never overrides an identity.

**`RD-VOICE`** The copy keeps its voice unless a rewrite was asked for. A visual pass is not a
content pass.

**`RD-A11Y`** What already works for assistive technology is not traded away for a look. Focus
states, alternative text, keyboard operation, and contrast are the first things to regress in a
restyle, and the first things to check once it is done.

## How far to go

**`RD-SCOPE`** Take the scope from the audit, not from ambition, and take the smallest one that
answers the brief. Each scope contains the ones above it.

| Scope | What changes | Take it when |
|---|---|---|
| **Surface** | Type scale, spacing rhythm, colour calibration | The structure works and the page reads as dated rather than wrong |
| **Response** | Surface, plus motion and interactive states on the components that already exist | The page is sound but feels inert, and nothing needs restructuring |
| **Funnel** | Response, plus the hero and the opening sections rebuilt around the real hierarchy | Readers leave before they work out what this is |
| **Rebuild** | Everything, in overhaul mode, with the content and the information architecture preserved | The markup or the structure itself is the debt |

When the brand itself is changing, none of these scopes apply: that is greenfield, and
`design-direction.md` governs from the start.

**`RD-SCOPE-ORDER`** Inside whichever scope you take, the work happens in one order: type and
spacing, then colour, then motion, then structure. Type and spacing are what a reader feels before
they read anything and what breaks nothing else, so every later decision is measured against them.

**`RD-DELIVER-AUDIT`** Even when no redesign is agreed, the audit is the deliverable. Report what is
broken, what is fine, and what each scope would buy. That report is useful on its own.
