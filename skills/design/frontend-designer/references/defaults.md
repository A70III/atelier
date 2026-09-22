# Defaults to Override

This file lists the specific defaults a language model reaches for when it is not reading the
brief. It exists because those defaults are what make generated design recognisable, and because
naming them is the only reliable way to steer past them.

Read every entry the same way: the named pattern is a **default**, and the line after it is the
**target**. These are not universal bans. When the brief names one of them, the brief wins, and the
job becomes executing it deliberately instead of drifting into it.

An entry ending in `-> RULE-ID` restates a requirement owned by that rule. This file is the
catalogue of what the pattern looks like; the named rule is the authority for what to do about it,
and it wins if the two ever disagree.

Its two highest-frequency members, in production experience, are the blue-violet glow and the
em dash. Those two are treated as hard rules rather than defaults, and are marked as such.

## Palette and effects

- **`DEFAULT-PURPLE`** The blue-violet accent, the indigo-to-fuchsia gradient, the purple glow behind a dark hero. *Instead:* derive the accent from the subject and its brand. If the brand is genuinely violet, use it with harmonised neutrals, a single accent, and no glow.
- **`DEFAULT-GRADIENT`** Gradient fills and mesh or aurora washes used as decoration, layered over a page that has nothing else to say. *Instead:* let the subject supply the atmosphere. A gradient that describes light, material, or depth is a design decision; a gradient that fills empty space is a default.
- **`DEFAULT-GRADTEXT`** Gradient-filled or transparent-clipped display text on a large heading. *Instead:* carry hierarchy with weight, scale, and colour.
- **`DEFAULT-GLOW`** Neon outer glows and blurred coloured halos around buttons and cards. *Instead:* use an inner border, a tinted shadow, or a change in surface tone.
- **`DEFAULT-PUREBW`** Pure `#000000` and `#ffffff` as page surfaces. *Instead:* an off-black and an off-white, so the page keeps depth.
- **`DEFAULT-CRAFTPAL`** Warm cream, brass, clay, or oxblood, with espresso text, on a premium consumer brief. This is the default palette for cookware, wellness, artisan, and heritage briefs, and it makes every such brand invisible. *Instead:* move to another family entirely: a cool metal grey with one warm neutral; a deep green with bone and a single amber note; off-black with tan; one saturated blue against a neutral; rust against cool grey; olive with brick; or full monochrome with one saturated accent. Derive the family from the subject's own material rather than from this list, and never ship the same family twice in a row.
- **`DEFAULT-GLASS`** Frosted glass on every surface because it looks current. *Instead:* reserve glass for a named purpose (media overlay, premium consumer surface, floating control), give it an inner border and a highlight, and provide a solid fallback under reduced transparency. Glass on a dense or trust-first surface is a default, not a decision.
- **`DEFAULT-SHADOWKIT`** One identical grey drop shadow under every card, whatever its rank. *Instead:* pick an elevation scale, tint shadows toward the surface, and delete most of them.

## Typography

- **`DEFAULT-INTER`** The most familiar UI sans, or a system font stack, as an unexamined default. *Instead:* choose a face that fits the subject. The familiar option is correct when the brief asks for neutral and standard.
- **`DEFAULT-SERIF`** A display serif chosen because "creative briefs use serifs". This is one of the most tested defaults in production. *Instead:* a display sans, or a serif the brand names, or a serif you can justify from a genuinely publication-led family, rotated so the same one does not appear twice.
- **`DEFAULT-SERIFDUP`** A small set of fashionable display serifs and the same ones every time. *Instead:* rotate from a deliberate pool and record which you used last time.
- **`DEFAULT-OVERH1`** A display heading at maximum size because large type feels designed. *Instead:* control hierarchy with weight and colour, and reserve extreme scale for two or three word headlines.
- **`DEFAULT-MIXFAM`** A serif word injected into a sans headline, or the reverse, to add interest. *Instead:* bold or italic of the same family. `-> TYPE-EMPHASIS`
- **`DEFAULT-CAPS`** All-caps micro labels as the default treatment for every label. *Instead:* sentence case, and drop the label when the content carries itself. `-> TYPE-TREATMENTS`
- **`DEFAULT-ORNAMENT`** Outlined, stroked, or animated-gradient text used as decoration. *Instead:* let the words be words.

## Layout and composition

- **`DEFAULT-3CARDS`** Three identical cards in a row as the feature section. *Instead:* keep three features and change the composition: an asymmetric grid, a stacked pair plus a wide tile, a scroll-pinned sequence, or a horizontal rail.
- **`DEFAULT-CARDKIT`** One radius, one shadow, one padding for every container regardless of rank. *Instead:* match container treatment to hierarchy, or drop the container and use spacing.
- **`DEFAULT-CENTERHERO`** A centred headline on a dark mesh as the automatic opening. *Instead:* split, left-align against an asset, or commit to a typographic composition that is the design. `-> COMP-CENTER`
- **`DEFAULT-SPLITHEAD`** A section header made of a large headline on one side with a short explanatory paragraph left hanging on the other. *Instead:* one message, stacked, or a second column that carries something real. `-> COMP-NOHEADER-SPLIT`
- **`DEFAULT-ZIGZAG`** Image-left, text-right, then the reverse, repeated down the page. *Instead:* at most two in a row, then a different family. `-> COMP-ZIGZAG`
- **`DEFAULT-SECTIONREPEAT`** One layout family doing duty for every section. *Instead:* at least four families across eight sections. `-> COMP-REPEAT`
- **`DEFAULT-BENTOEMPTY`** A tile grid with a gap where content should be. *Instead:* reshape the grid to the content that exists. `-> BENTO-COUNT`
- **`DEFAULT-OVERLAP`** Elements placed at awkward offsets with no compositional reason, leaving uneven gaps. *Instead:* align deliberately or break the grid deliberately.
- **`DEFAULT-HAIRLINE`** Hairlines and crosshair marks added so the page will look considered. *Instead:* a rule that marks a real boundary, and nothing else.

## Template chrome

- **`DEFAULT-EYEBROW`** A small uppercase, wide-tracked label above every section heading, producing an identical rhythm page after page. *Instead:* at most one per three sections, or none. This one is countable: count the instances before shipping. `-> COMP-EYEBROW`
- **`DEFAULT-NUMBERED`** Templates that appear whatever the subject: `00 / START`, `001 / Features`, `05 / Pricing`, `Stage 1`, `Step 2`, `Phase 01`, `Pass One`. *Instead:* name the thing itself, and use numbering only when the content genuinely is an ordered sequence.
- **`DEFAULT-VERSION`** Version stamps and build identifiers as page chrome: `v0.6`, `BETA`, `INVITE-ONLY`, `build 41`, `synced 4s ago`. *Instead:* save them for developer surfaces that need them.
- **`DEFAULT-ARROW`** An arrow appended to a link or button label (`Continue →`). *Instead:* let the label carry the meaning, and mark the link as a link with an underline or a colour.
- **`DEFAULT-DOT`** A coloured status dot before navigation items, list rows, or labels. *Instead:* one dot, only where it reports real state.
- **`DEFAULT-MIDDLEDOT`** Metadata chains built from middle dots: `A · B · C · D`. *Instead:* line breaks, columns, or a single separator, and never a chain longer than one dot per line.
- **`DEFAULT-STRIP`** A decorative band of words sitting under the hero: `FORM. MATERIAL. LIGHT.`, `CRAFT / TYPE / MOTION`, `EST. 2019 · PORTO`. *Instead:* a band that carries real navigation or real status, or nothing.
- **`DEFAULT-ROTATED`** Text rotated ninety degrees down the edge of the page. *Instead:* horizontal text, unless the brief is explicitly exhibition-led and the rotation does compositional work.
- **`DEFAULT-PILLIMG`** Tags and pills overlaid on photographs: `Plate · Brand`, `Field notes`, `Brand · 02`. *Instead:* let the image stand, or caption it outside the frame.
- **`DEFAULT-PHOTOCREDIT`** Decorative photo credits under stock imagery: `Field study no. 12`, `Frame XII · 35mm`. *Instead:* credit a real photographer of a real photograph, or write one functional caption.
- **`DEFAULT-LOCALE`** Locale, city, time, and weather strips used as atmosphere: `LIS 14:23`, `Lisbon, working with founders`. *Instead:* keep the footer address, and drop the atmosphere. Allowed only for a place-based brand, a distributed studio whose time zones matter, or a real venue.
- **`DEFAULT-SCROLLCUE`** "Scroll", "↓ scroll", "Scroll to explore", and animated mouse icons. *Instead:* trust the reader. They know what scrolling is.
- **`DEFAULT-STOCKCOUNT`** Live counters as decoration: `Reservation 412 of 800`. *Instead:* only when the number is real and the brief is a limited run.
- **`DEFAULT-SCOREBAR`** Filled background tracks with a partial fill used as a comparison graphic. *Instead:* a number with a small mark, or an inline bar with no track.
- **`DEFAULT-SUBTEXTCR`** A short paragraph parked in a corner of the section header. *Instead:* put it under the headline, or give the corner something to do.

## Content and copy

- **`DEFAULT-POETIC`** Performative-craftsman labels: `From the field`, `Field notes`, `On the bench`, `Loose plates`. *Instead:* plain labels such as `Testimonials`, `Recent writing`, `In progress`, or no label at all. `-> COPY-AUDIT-CRAFTSMAN`
- **`DEFAULT-QUIETTRUST`** Social-proof headers written to sound understated: `Quietly in use at`. *Instead:* say `Trusted by` or `Customers include`, or let the marks carry the section with no heading at all.
- **`DEFAULT-MOCKHUMBLE`** Jokes and in-industry asides in body copy that read as personality. *Instead:* say the thing.
- **`DEFAULT-MICROMETA`** A sentence explaining the section under its own heading. *Instead:* heading plus body, nothing in between.
- **`DEFAULT-JANEDOE`** Placeholder people: John Doe, Jane Doe, Sarah Chan. *Instead:* realistic, locale-appropriate names.
- **`DEFAULT-AVATAR`** Generic avatar shapes and default user glyphs as portraits. *Instead:* believable imagery, or a deliberate typographic monogram.
- **`DEFAULT-SLOPNAME`** Invented startup names that sound like a generator: Acme, Nexus, SmartFlow, Cloudly. *Instead:* names that sound like a real company in this industry.
- **`DEFAULT-SLOPVERB`** Marketing abstractions standing where a concrete verb belongs: *elevate*, *unleash*, *seamless*, *next-gen*, *cutting-edge*, *revolutionize*. *Instead:* a verb that names what the reader actually does.
- **`DEFAULT-ROUNDNUM`** Suspiciously round or perfect figures: 99.99%, 100%, 50%, 1234567. *Instead:* real data, or numbers that look gathered rather than authored, still labelled if they are samples. `-> CONTENT-NUMBERS`
- **`DEFAULT-FAKESPEC`** Invented precision the brand never claimed: 4.2 mm, 11.8 lb, 3.6×. *Instead:* only numbers from the brand, or visible sample data. `-> CONTENT-NUMBERS`
- **`DEFAULT-AICOPY`** Cute-but-wrong wordplay and mock-thoughtful phrasing. *Instead:* a plain functional sentence, and re-read every string before finishing. `-> COPY-AUDIT-MOCK`
- **`DEFAULT-LOREM`** Lorem ipsum shipped as if it were content. *Instead:* write real copy for the subject, or label the block as placeholder.

## Code

- **`DEFAULT-DIVFAKE`** A product interface built from styled rectangles to stand in for a screenshot. *Instead:* a real or generated image, a genuine miniature component, or nothing. `-> ASSET-NOFAKE`
- **`DEFAULT-HANDICON`** Icons drawn by hand as raw path data. *Instead:* an icon library. Composing from library primitives is fine; tracing a glyph is not. `-> ASSET-SVG`
- **`DEFAULT-EMOJI`** Emoji used as structural icons in navigation, lists, or controls. *Instead:* vector icons. Emoji are acceptable only in a genuinely social or chat-native voice, and even then sparingly.
- **`DEFAULT-LUCIDE`** Reaching for the most defaulted icon set out of habit. Prefer Phosphor, HugeIcons, Radix Icons, or Tabler. *Instead:* one family per project, one stroke width, one filled-versus-outline discipline per level.
- **`DEFAULT-MIXICONS`** Two icon families in one tree. *Instead:* one family, extended by composition.
- **`DEFAULT-MIXDS`** Two component libraries in one tree, or one system's tokens imported and then overridden everywhere. *Instead:* one system, used as documented.
- **`DEFAULT-HSCREEN`** `h-screen` for a full-height section. *Instead:* the dynamic viewport unit, so mobile browser chrome does not jump the layout. `-> LAYOUT-VIEWPORT`
- **`DEFAULT-SCROLLLISTENER`** `window.addEventListener('scroll', ...)`, or reading `window.scrollY` into React state. *Instead:* a motion value, a scroll-trigger library, an intersection observer, or a CSS scroll-driven animation. `-> MOTION-BANNED`
- **`DEFAULT-USESTATEINPUT`** React state driving continuous pointer or scroll values, which re-renders the tree on every frame. *Instead:* motion values and transforms outside the render cycle. `-> MOTION-BANNED`
- **`DEFAULT-LAYOUTANIM`** `transition: all`, and transitions on width, height, top, or left. *Instead:* transform and opacity, with the specific properties named. `-> MOTION-HARDWARE`
- **`DEFAULT-RAWHEX`** Hard-coded hex values scattered through components. *Instead:* semantic tokens defined once, mapped per theme.
- **`DEFAULT-ZSPAM`** Arbitrary high z-index values used to win a stack fight. *Instead:* one documented layer scale.
- **`DEFAULT-UNUSEDLAYOUT`** Animation layout props wrapped around static content as insurance. *Instead:* apply them where the layout genuinely changes.

## Marks and punctuation

- **`DEFAULT-EMDASH`** Hard rule. The em dash, and the en dash used as a separator, do not appear in any string a user sees: headline, label, pill, button, caption, quote, attribution, alt text, or body. It is the single most reliable sign of machine-written interface copy. *Use instead:* the hyphen, a period, a comma, a colon, or parentheses. Date and number ranges use a plain hyphen.
- **`DEFAULT-STRAIGHTQUOTE`** Straight ASCII quotation marks and apostrophes in polished interface copy. *Instead:* typographic marks, or no quotation marks at all.
- **`DEFAULT-BRBREAK`** A headline broken by a hard line break and italicised for effect. *Instead:* let the headline read naturally first.

## Using this file

Two moves, always in this order:

1. **Mechanical.** Run `scripts/scan-defaults.sh` over the target. It detects the countable and
   greppable members of this list and reports `file:line` with the rule id. Fix each hit, or confirm
   it as a false positive and say so.
2. **Judgment.** Walk the rest of the list against the page. A pattern is present but correct when
   the brief asked for it. In that case, say which entry applies and why it is intentional, rather
   than letting it pass unremarked.

Do not over-correct. A page that avoids every default by refusing all colour, motion, and structure
is not designed, it is evacuated. The target is a page that could only have been made for this
subject.
