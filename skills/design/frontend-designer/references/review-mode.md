# Review Mode

Use this when the task is to look at existing UI and say what is wrong with it. The output is
findings, not a rewrite. Only change code when the person asks for changes after reading them.

## Scope

**`RV-INPUT`** The person may name files, a glob, a directory, or a URL. If nothing is named, ask
which files or pattern to review, and do not guess. When a whole project is named, start from the
entry pages and the components they render.

**`RV-STACK`** Detect the stack from the project files so the findings speak the same language as
the code (`package.json`, `pubspec.yaml`, `composer.json`, `*.xcodeproj`, config files).

**`RV-SCOPE-OUT`** Web only. Native platform UI, data-grid internals, code-editor configuration, and
wizard state machines are out of scope. Say so if the target is one of those.

**`RV-NOCHANGE`** Report first. Do not refactor while reviewing, and do not present a partial rewrite
as a review.

## How to run it

1. **Collect the rules.** Read the rule sets that apply to the surfaces in scope: `accessibility-ux.md` for correctness, `defaults.md` for defaults that have crept in, `build-discipline.md` for layout, composition, states, assets, and density, `interface-copy.md` for anything a person reads, and `design-direction.md` for direction-level problems such as no declared direction or a defaulted palette.
   *Done when:* you know which rule ids apply before you open a single component.
2. **Run the mechanical pass.** `scripts/scan-defaults.sh <target>`. Record every hit with its rule id.
   *Done when:* the scanner has run, or you have said that bash is unavailable and the mechanical pass was skipped.
3. **Run the contrast pass.** Every declared foreground and background pair goes through `scripts/contrast.py`, at the right threshold for its text size. Unresolvable pairs from translucent surfaces are measured against the composed background, not the intended one.
   *Done when:* every declared pair has a measured ratio, and pairs that cannot be measured are named as unmeasured.
4. **Walk the rule sets against the code.** Group by category, not by file, and check each rule. Open the file for every candidate finding before recording it.
   *Done when:* every rule id in scope has been considered, even if the answer is that it passes.
5. **Triage and report.**
   *Done when:* every finding carries a rule id, a location, and a concrete fix.

**`RV-ORDER`** Report in this order, because it is also the order of consequence:

1. **Correctness.** Contrast failures, unreachable or invisible focus, missing accessible names, missing labels, target sizes below the floor, layout that breaks on a phone, content hidden behind fixed bars, colour carrying meaning alone.
2. **Structure and defaults.** A direction that was never chosen, a defaulted palette, template chrome, a repeated layout family, an unbounded list, a fake screenshot, invented copy.
3. **Craft.** Type scale, spacing rhythm, shadow and radius discipline, motion that is unmotivated or missing its reduced-motion path, density, wording.

**`RV-FORMAT`** One line per finding:

> `path/to/file.tsx:41 — HERO-FITS — primary action sits below the fold; headline is four lines — cut the subtext to one sentence and drop the display size one step`

Include the rule id so the person can look the rule up. Include the fix in the same line so the
finding is actionable without a second round trip.

**`RV-SEVERITY`** Use three levels and no more: **breaks** (a person cannot use it), **defaults**
(it reads as generated), **polish** (it is usable and specific, but rough). Do not invent a numeric
score.

**`RV-CHERRY`** End with the three changes with the highest ratio of effect to effort. A review that
lists forty equal findings buries the ones worth doing first.

**`RV-FALSEPOSITIVE`** Confirm every candidate before reporting it. Open the file. A pattern inside a
code fence, a comment, or an example is not a finding. A pattern the brief asked for is not a
finding. When a rule genuinely does not apply, say that it was checked and passed rather than
staying silent, so the person knows the pass was run.

**`RV-NOHARSH`** Describe the pattern and its effect. Do not attribute intent, and do not call the
work bad. "This reads as generated because every section opens with the same label" is a finding.
"This was done lazily" is not.
