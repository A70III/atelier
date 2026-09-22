# Design Direction

Everything that happens before the first line of code. Get this wrong and no amount of polish
saves the page, because the page is answering the wrong question.

## Direction

Everything here happens before the first line of code. Get it wrong and no amount of polish saves
the page, because the page is answering the wrong question.

### What decides the answer

Five things, in this order. A later one can overturn an earlier one, which is why the order matters.

**`DIR-SUBJECT`** What the page is, concretely. Not the category: the thing. The product, the
person, the service, the event. If the brief never says, decide, keep it to one concrete subject,
and confirm it while you work. Everything downstream is drawn from that subject's own material, its
vocabulary, its imagery, its palette, its type. A page for a small-batch ceramic studio should be
identifiable as one before a word is read.

**`DIR-READER`** Who reads it, and what they are deciding. A procurement panel comparing vendors, a
reader deciding whether to buy a paperback, someone who has already been told they must file
something. That decision fixes the order of the page and the register of its copy. The maker's own
taste is not a signal.

**`DIR-CONSTRAINTS`** What cannot be traded away. A statutory body, a regulated market, an audience
that depends on assistive technology, a purchase that has to feel safe, a product for children, a
script that is not Latin. These outrank every aesthetic preference, and they are settled before the
look is chosen rather than after.

**`DIR-ASSETS`** What the brand already owns: mark, palette, typeface, photography, an existing
site, a printed catalogue. Where any of it exists you inherit it rather than invent it, and the
invention starts from there. Throwing away an owned asset is a decision that has to be argued.

**`DIR-FIELD`** What the category already looks like. Named competitors, links the client sent,
screenshots they pasted, the conventions a reader of this category expects. This tells you two
things: which conventions to keep, because the reader needs them, and which to break, because every
competitor is already using them. A reference the client sends outranks anything inferred from the
other four.

**`DIR-WORDS`** The adjectives the client used about the feel, treated as instructions with a cost
rather than as mood. Translate each one before using it: "premium" means restraint and spending
space; "playful" means something moves and something sits deliberately off the grid; "trust" means
the familiar conventions stay. An adjective you cannot turn into an implementation decision has not
been understood yet.

### The direction record

**`DIR-RECORD`** Write this block before any code, and keep it visible for the rest of the run.

> **Subject** the concrete thing the page is about
> **Reader** who they are and the decision in front of them
> **Register** how it should feel to read, in the reader's terms
> **Material logic** where the visual language is taken from, and why that source is true to the subject
> **Stack lean** the lightest thing that carries this: a named system, or hand-built tokens
> **Refused** the two or three defaults this brief invites and that will not ship

**`DIR-REFUSALS`** The refusal line is not optional, and it is the most useful one in the record.
Every brief pulls toward a small number of habitual answers, and the habitual answer that nobody
wrote down is the one that ships. Name it, then name what replaces it. `defaults.md` is the
catalogue to choose from.

Two worked examples, showing the shape rather than the content:

> **Subject** a small imprint's paperback list; **Reader** Thai readers who buy paper books and want
> to know what the house publishes; **Register** calm, unhurried, printed rather than digital;
> **Material logic** the printer's workshop: uncoated stock, ink, cloth, a typographic cover plate;
> **Stack lean** plain HTML and CSS, with a small script for the menu and the reveals;
> **Refused** the cream-and-brass craft palette, a cover faked from a photograph, an eyebrow above every heading.

> **Subject** a statutory service for reporting a change of address; **Reader** someone already told
> they must do this, worried about getting it wrong; **Register** plain and literal, with no
> reassurance they cannot verify; **Material logic** the government system the brief names, unaltered;
> **Stack lean** that system's own components and nothing else;
> **Refused** illustrative hero imagery, motion beyond focus and press, any wording that promises an outcome.

**`DIR-ASK`** Ask one question, never a set, and only when the record genuinely forks between two
readings you can describe in a sentence. If context already answers it, do not ask: write the record
and move.

### Magnitudes

Three numbers, set from the record and used by name for the rest of the run. Each runs 1 to 5. They
are the only global settings; do not invent parallel ones.

| | 1 | 3 | 5 |
|---|---|---|---|
| `ASYMMETRY` | one column, equal weights, everything on the grid | offset blocks, mixed proportions, one element breaking the container | fractional grid, overlapping layers, large voids, a composition that ignores the container |
| `MOTION` | nothing moves but focus and press | transitions, and one arrival per section | pinned sections, scrubbed sequences, directed choreography |
| `DENSITY` | one idea per screen, generous voids | ordinary reading rhythm | tight padding, rules instead of boxes, tabular figures |

**`MAG-DEFAULT`** With nothing in the record to go on, start at 3 / 2 / 3 and say that is what you
are using. Silence is not a signal.

**`MAG-ASYMMETRY`** Raise it when the page's job is to be remembered, when one dominant object is
worth building the composition around, or when the category's convention is a centred column and the
brief asks to stand apart. Lower it when the reader is hunting for a specific fact, when the content
is a comparison, or when the brand already carries the difference. 2 is a legitimate answer: a
composed symmetrical page is not the same as an unconsidered one.

**`MAG-MOTION`** Raise it when the page tells a sequence, when there is a real object to inspect, or
when the register is energetic. Lower it when the reader is anxious, when the content is reference
material they will come back to, or when the page is read on a phone in a hurry. A page claiming 4
that does not move is broken; if the scope cannot carry working motion, lower the number.

**`MAG-DENSITY`** Raise it when the reader has to compare many things at once, when the subject is
technical, or when the page is a working surface. Lower it when the subject is sparse, when each
item deserves its own screen, or when space is the material the design is made of.

**`MAG-CONFLICT`** Constraints settle it first: anything named in `DIR-CONSTRAINTS` caps `MOTION` at
2 and sets a floor of 3 on `DENSITY`. After that the reader's decision decides `ASYMMETRY`, and the
translated adjectives decide `MOTION` and `DENSITY`. Where those disagree, whichever serves the
reader's decision wins, and the tie-break is the rule that prevents a templated default.

**`MAG-REPORT`** State the three numbers in the same message as the record, one line of reason each.
A number with no reason cannot be argued with, and an unarguable setting is a guess.

**`MAG-MOBILE`** Any `ASYMMETRY` above 3 collapses to a single column below 768px, written into the
component rather than hoped for.

## Foundation

**`DS-HONESTY`** When the brief reads as an established system, install that system's official
package and build with it. Rebuilding the system's CSS yourself, or importing its tokens and then
overriding nearly all of them, is the failure this rule exists to prevent.

| The brief reads as | Use the official package for |
|---|---|
| Microsoft, enterprise SaaS, admin surfaces | Fluent UI |
| Google-flavoured product UI | Material 3 (Material Web or the platform's Material library) |
| IBM-style enterprise analytics | Carbon |
| Atlassian-style product | Atlassian Design System |
| GitHub-style developer or community surface | Primer, or Primer Brand for marketing pages |
| UK public service | GOV.UK Frontend |
| US public service | USWDS |
| Shopify app surfaces | Polaris |
| A modern accessible React foundation | Radix Themes |
| A product where the team owns the components outright | shadcn/ui, restyled, never shipped in its stock state |
| An indie or small-team marketing build | Tailwind with a hand-built token set |

**`DS-ONE`** One system per project. Never two component libraries in the same tree. Never a
second system's primitives dropped into the first.

**`DS-AESTHETIC`** When the look has no official package behind it, build on hand-written CSS plus
one maintained component library, and comment wherever you approximate a published spec instead of
following it.

| Aesthetic | Honest implementation |
|---|---|
| Glass or frosted panels | Layered borders, backdrop filter, highlight overlay, and a solid fallback under reduced transparency |
| Bento tile grids | CSS Grid with unequal cells |
| Brutalist, editorial, dark technical | Native CSS: raw borders and monospace, or serif and asymmetric columns, or mono with one accent |
| Aurora or mesh atmospheres | Layered radial gradients or SVG, used as atmosphere, never as a substitute for content |
| Kinetic typography | Native animation, scroll-driven animation, or a directed library |
| Anything documented by a platform vendor for that platform only | An approximation, labelled as one |

Before reaching for a package, confirm what the project already has. Detection and dependency
verification are owned by `build-discipline.md`, section *Stack*.

## Grounding: subject to palette and type

**`COLOR-SUBJECT`** The palette comes from the subject's own material: its industry, its physical
materials, its era, its references. Four to six named hex values for the base, described in words
as well as codes. It never comes from the set a model reaches for by habit; `defaults.md` enumerates
those families and the rotation to use instead.

**`COLOR-ACCENT-ONE`** One accent governs the whole page. Once it is chosen, it appears on every
section. A page whose palette is warm grey does not sprout a blue button in its seventh section. Audit every
component against the accent before shipping.

**`COLOR-SATURATION`** Default to accents below roughly 80 percent saturation, against neutral
bases. Desaturate until the accent reads as a decision rather than a shout.

**`TYPE-ROLES`** One family, or two at the very most, and a pair of faces has to read as a
deliberate pairing. Set a type scale and state the roles: display, body, and any mono used for data.

**`TYPE-README`** Choose faces deliberately rather than reaching for the one you would use on any
project. A pairing worth naming: a grotesque display with a neutral text companion, or a characterful
display with a mechanical mono for data.

**`TYPE-SERIF`** A serif earns its place only when the brand names one, or when the family is
genuinely editorial, publication, luxury, or heritage and you can say why this face suits this
brand. Everywhere else the display goes in a sans, which is the unmarked choice: it reads as a
decision not to decorate, and that is usually correct.

**`TYPE-EMPHASIS`** To emphasise a word inside a headline, use bold or italic of the same family.
Setting one word of a sans headline in a serif to add interest reads as a beginner's trick.

**`TYPE-MARKS`** Line height has to clear the tallest and deepest marks a script stacks. Latin
italics clip at a line height of 1, so any display word containing `y`, `g`, `j`, `p`, or `q` takes
at least 1.1 with a little space reserved below. Thai and other scripts that stack tone marks above
and vowels below need the same reserve on every line, and more of it at display size. Audit the
display type for clipped marks before shipping.

**`TYPE-SCRIPT`** For a script other than Latin, the Latin defaults do not transfer. Thai sets no
spaces between words, so leave `overflow-wrap` and `word-break` at their defaults and let the
browser's own line-breaking dictionary do the work. Letter-spacing damages mark positioning and is
left alone. There is no case to transform, so no uppercase treatment applies. Body line height goes
to about 1.8, and the prose measure is set from the script's own character widths rather than from
`ch`.

**`TYPE-LINELENGTH`** Body text under 80 characters per line, near 65 to 75 on desktop, 35 to 60 on
mobile. Serif faces take a slightly longer line and slightly more line height than sans.

**`TYPE-TREATMENTS`** Do not accent a single word in a headline with a colour or an italic as a
design move. Do not set labels in caps as a habit. Do not stack small typographic labels above
content that does not need them. When type is the visual, treat the type itself as the design
rather than as a delivery vehicle.

## The plan

Produce the plan as a short block, then attack it.

**`PLAN-TOKENS`** Four to six named hex values for the base palette, plus the type roles, plus the
accent, plus the surface and text pairs you will check for contrast.

**`PLAN-LAYOUT`** One sentence per section, plus an ASCII wireframe for the page. Sketch two
options when the composition is genuinely open, and say which you chose and why. Include the
alignment rule: what is left-aligned, what is centred, what is intentionally off-grid.

**`PLAN-PRINCIPLES`** Two or three sentences on what makes this page specific: the one flourish,
the material logic, the rule that decides contested cases.

**`PLAN-ATTACK`** Before writing code, compare the plan against the brief. Ask of each part: could
this have been produced for a similar brief without reading this one? For every part where the
answer is yes, revise it, and say what changed. Only then write the code.

**`PLAN-STRUCTURE`** Visual structure carries information. Outlines, rules, numbering, dividers, and
labels earn their place by encoding something true about the content. Numbered markers belong to a
real sequence. A divider belongs where a boundary exists. Decoration that encodes nothing is a
tell.

## Canonical sources

Consult the vendor's own documentation before inventing an API or a token name. The package name is
the lookup; let the package's docs supply the install command rather than caching one here.

- Fluent UI, Material 3, Carbon, Atlassian Design System, Primer, GOV.UK Frontend, USWDS, Polaris, Radix Themes, shadcn/ui, Bootstrap, Tailwind, Motion: each has a first-party documentation site.
- Native CSS behaviour: MDN for `backdrop-filter`, `prefers-color-scheme`, `prefers-reduced-motion`, `prefers-reduced-transparency`, Grid, and scroll-driven animations.
- Vendor-platform materials documented for that platform only stay approximations on the web, labelled as such.
