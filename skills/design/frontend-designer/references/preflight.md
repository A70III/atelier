# Pre-Flight

The last gate before anything is called done. Rule ids in brackets point at the file that defines
them, so a failed box is never a matter of opinion.

**Run this whole list. A box that cannot be honestly ticked means the work is not done.** Name the
box, fix it, and run the gate again. Never present the work as finished with an unticked box, and
never tick a box for a check you did not run.

## Mechanical results

- [ ] `scripts/scan-defaults.sh <target>` was run, and it exits 0. Every hit was fixed, or confirmed as a false positive with the reason stated. `[defaults]`
- [ ] The scan covered the whole target, not one entry file: every markup, stylesheet, and script in the tree. A clean result on the entry page alone is not a scan.
- [ ] Every declared colour pair was measured with `scripts/contrast.py`, at the threshold for its text size. `[AX-CONTRAST]`
- [ ] If bash was unavailable, the mechanical pass was skipped **and that was said out loud**.

## Direction

- [ ] The direction record was written before any code, with all six lines filled in. `[DIR-RECORD]`
- [ ] At most one clarifying question was asked, and only because the direction genuinely diverged. `[DIR-ASK]`
- [ ] The direction is grounded in the subject, and would not fit a neighbouring brief. `[DIR-SUBJECT]`
- [ ] The refusal line names at least two defaults this brief invited, each with its replacement. `[DIR-REFUSALS]`
- [ ] All three magnitudes are stated with a justification, and none was inherited from the default silently. `[MAG-DEFAULT]`
- [ ] The plan was attacked against the brief, what changed was stated, and the change was more than wording. `[PLAN-ATTACK]`
- [ ] One flourish carries the page, and everything around it is held back. `[SKILL.md principles]`
- [ ] The mode was detected, and for a redesign the audit preceded any proposal. `[RD-MODE] [RD-AUDIT]`

## Foundation and palette

- [ ] The foundation is named, and one system governs the project. `[DS-ONE]`
- [ ] When a system fits, its official package is used, with no hand-rebuilt CSS and no token overrides. `[DS-HONESTY]`
- [ ] Every dependency used was verified against the project before it was imported.
- [ ] The palette is derived from the subject's own material. `[COLOR-SUBJECT]`
- [ ] One accent governs the whole page, with no stray second accent in a later section. `[COLOR-ACCENT-ONE]`
- [ ] No blue-violet or indigo-to-fuchsia default, and no purple glow, unless the brand asked for it and it was executed deliberately. `[DEFAULT-PURPLE]`
- [ ] No gradient used as decoration, no gradient display text, no neon halo. `[DEFAULT-GRADIENT] [DEFAULT-GRADTEXT] [DEFAULT-GLOW]`
- [ ] No pure black and pure white as surfaces. `[DEFAULT-PUREBW]`
- [ ] A premium-consumer brief did not land on the warm cream and brass family, and the palette family differs from the last similar project. `[DEFAULT-CRAFTPAL]`
- [ ] Glass appears only where it has a named reason, with a solid fallback under reduced transparency. `[DEFAULT-GLASS]`
- [ ] Elevation is a scale, not one shadow copied onto every container. `[DEFAULT-SHADOWKIT]`
- [ ] Dark mode was designed from the start and tested on its own. `[AX-DARKMODE]`

## Typography

- [ ] The display face was chosen for this subject rather than defaulted to the most familiar UI sans. `[DEFAULT-INTER]`
- [ ] A serif was used only with a brand reason or a genuinely publication-led family, and a different serif from the previous project. `[TYPE-SERIF] [DEFAULT-SERIFDUP]`
- [ ] At most two families, with clearly distinct roles. `[TYPE-ROLES]`
- [ ] Emphasis inside a headline uses bold or italic of the same family. `[TYPE-EMPHASIS]`
- [ ] Line height clears the tallest and deepest marks the script stacks, at display size as well as in body. `[TYPE-MARKS]`
- [ ] For a non-Latin script, line breaking, letter-spacing, case treatment, leading, and measure follow that script rather than the Latin defaults. `[TYPE-SCRIPT]`
- [ ] Body line length sits inside the desktop and mobile targets. `[TYPE-LINELENGTH]`
- [ ] No single-word italic or colour accent, no habitual all-caps labels, no unnecessary label above content. `[TYPE-TREATMENTS]`

## Layout

- [ ] The hero fits the first viewport, with the primary action visible without scrolling. `[HERO-FITS]`
- [ ] Hero type scale was planned together with the asset, and the headline is two lines at desktop. `[HERO-SCALE]`
- [ ] Hero top padding is capped, and the content does not hang in the middle of the viewport. `[HERO-PADDING]`
- [ ] The hero holds at most four text elements, with no trust strip, tagline, pricing note, or bullet list inside it. `[HERO-STACK]`
- [ ] The hero carries a real visual, not type over a gradient. `[HERO-VISUAL]`
- [ ] The navigation renders on one line at desktop, within the height cap, with the space it covers reserved. `[NAV-ONELINE] [NAV-HEIGHT]`
- [ ] Breakpoints come from one systematic set, and the layout is contained in a shared maximum width. `[LAYOUT-BREAKPOINTS] [LAYOUT-CONTAINER]`
- [ ] Full-height sections use the dynamic viewport unit, never `h-screen`. `[LAYOUT-VIEWPORT]`
- [ ] Columns use grid, not percentage flex arithmetic. `[LAYOUT-GRID]`
- [ ] Every multi-column layout declares its below-768px collapse in the same component. `[LAYOUT-MOBILE]`
- [ ] No horizontal scrolling at any width, including on long labels and wide tables. `[LAYOUT-NOSCROLL]`
- [ ] The z-index scale is documented and nothing fights the stack with an arbitrary value. `[LAYOUT-ZINDEX]`
- [ ] One theme governs the page, with no unexplained inversion mid-scroll. `[COMP-THEME-LOCK]`

## Composition

- [ ] `ASYMMETRY` is expressed through real devices, and there is no centred default above 3. `[COMP-VARIANCE] [COMP-CENTER]`
- [ ] No layout family appears twice on the page, and at least four families appear across eight sections. `[COMP-REPEAT]`
- [ ] No three consecutive image-and-text split sections. `[COMP-ZIGZAG]`
- [ ] Cards are used only where elevation carries hierarchy, and one radius system applies throughout. `[COMP-CARDS] [COMP-SHAPE-LOCK]`
- [ ] No section header built as a big headline with a small explainer floating in the opposite column. `[COMP-NOHEADER-SPLIT]`
- [ ] The eyebrow count is at or below one per three sections, counted mechanically, with the hero counted as one. `[COMP-EYEBROW]`
- [ ] Any tile grid's cell count matches its content count, its composition varies, and at least two or three cells carry real visual variety. `[BENTO-COUNT] [BENTO-RHYTHM] [BENTO-VARIATION]`
- [ ] Any list of six or more items uses a real component instead of a plain list, and a specification table was restructured rather than ruled per row. `[LIST-COMPONENT] [LIST-SPEC]`
- [ ] At most one marquee on the page. `[LIST-MARQUEE]`

## States and actions

- [ ] Loading, empty, and error states exist, and loading skeletons match the layout they replace. `[STATE-LOADING] [STATE-EMPTY] [STATE-ERROR]`
- [ ] Press feedback exists, does not shift layout, and arrives within about a tenth of a second. `[UX-PRESS] [MOTION-PRESS]`
- [ ] Every button label fits on one line at desktop. `[CTA-ONELINE]`
- [ ] One label per intent across the whole page. `[CTA-INTENT]`
- [ ] Forms put the label above the field, with helper text where it helps and the error below the field. `[FORM-LAYOUT]`

## Motion

- [ ] Every animation answers the hierarchy, storytelling, feedback, or state-change question in one sentence. `[MOTION-MOTIVATED]`
- [ ] If `MOTION` is above 3, the page actually moves, and nothing half-built was shipped. `[MOTION-CLAIMED]`
- [ ] Only transform and opacity are animated. `[MOTION-HARDWARE]`
- [ ] The page uses one set of durations and easings, with exits faster than entries. `[MOTION-TIMING]`
- [ ] Motion is isolated in client leaves with effect cleanup, and no scroll-trigger or WebGL library shares a tree with the motion library. `[MOTION-ISOLATE] [MOTION-NOMIX]`
- [ ] No scroll event listener, no scroll position in component state, no animation-frame loop setting state, no animated layout property. `[MOTION-BANNED]`
- [ ] Reduced motion resolves everything above the subtle level to its static final state. `[MO-REDUCED]`
- [ ] Motion never blocks input and never gates correctness. `[MO-NOBLOCK]`
- [ ] Pinned and scrubbed sequences use the canonical settings, including the correct start, pin, and scrub. `[interaction-motion: Skeletons]`

## Accessibility

- [ ] Text clears 4.5:1, large text 3:1, and meaningful non-text elements 3:1, measured against the composed background. `[AX-CONTRAST] [AX-NONTEXT]`
- [ ] Colour is never the only signal. `[AX-COLORONLY]`
- [ ] Everything interactive is keyboard operable, in visual order, and focus is always visible and never obscured. `[AX-KEYBOARD] [AX-FOCUS]`
- [ ] One main region, a skip link, one heading level one, and no skipped heading levels. `[AX-LANDMARKS]`
- [ ] Every control has an accessible name; decorative icons are hidden and meaningful icons have a text alternative. `[AX-NAMES]`
- [ ] Meaningful images have descriptions and decorative images are hidden. `[AX-ALT]`
- [ ] Status and count changes are announced without moving focus. `[AX-STATUS]`
- [ ] Targets clear the 24px floor and comfortably reach 44px, with separation between them. `[UX-TARGET] [UX-TARGET-GAP]`
- [ ] Nothing is reachable by hover alone. `[UX-NOHOVERONLY]`
- [ ] Platform gestures and zoom are not blocked, and horizontal swipe does not hijack the main scroll. `[UX-SCROLL-HIJACK] [UX-GESTURE-STD]`
- [ ] Every field has a visible, programmatically associated label, with errors beside the field stating cause and fix. `[FM-LABELS] [FM-ERRORS]`
- [ ] A multi-error submit focuses a linked summary and keeps the inline errors. `[FM-SUMMARY]`
- [ ] Errors and statuses reach assistive technology without stealing focus. `[FM-LIVE]`
- [ ] Validation runs on blur, not on every keystroke. `[FM-VALIDATE-TIME]`
- [ ] Inputs use semantic types and autocomplete attributes. `[FM-INPUT-TYPE]`
- [ ] The current location is indicated in the navigation, back behaves predictably, and key screens are deep-linkable. `[NV-STATUS] [NV-BACK] [NV-DEEPLINK]`
- [ ] Body text is at least 16px on mobile, and the page reflows to 320px without two-dimensional scrolling. `[RESP-TEXT] [AX-REFLOW]`
- [ ] Text scales to 200 percent without clipping or truncation. `[AX-ZOOM]`
- [ ] Fixed headers, footers, and action bars respect safe areas and reserve their space. `[RESP-FIXED]`
- [ ] Chip and badge collections wrap before their labels shrink, and truncation is disclosed. `[RESP-LABEL-OVERFLOW]`
- [ ] Any chart has a text summary, a data alternative, a visible legend, keyboard-reachable tooltips, and loading, empty, and error states. `[CH-ALTERNATIVE] [CH-LEGEND] [CH-INTERACT] [CH-STATES]`
- [ ] Auto-moving content can be paused, halts while focused, and halts under reduced motion. `[AX-ROTATION]`
- [ ] Every drag interaction can also be completed with one pointer press and with the keyboard. `[AX-DRAG-ALT]`

## Assets

- [ ] Real imagery is present, in priority order: generated, then real photography, then a labelled placeholder slot listed when you report back. `[ASSET-ORDER]`
- [ ] No product preview is built from styled rectangles. `[ASSET-NOFAKE]`
- [ ] A trust wall uses real marks or generated monograms, renders in both themes, and carries logos only. `[ASSET-LOGOS]`
- [ ] Icons come from one library family with one stroke width, and any decorative SVG was asked for or is a single simple mark. `[ASSET-SVG] [DEFAULT-HANDICON] [DEFAULT-MIXICONS]`
- [ ] A page with no imagery at all does not ship as minimalism; decorative work uses real or generated imagery. `[ASSET-DECOR]`
- [ ] No image whose subject carries meaning is stood in for by a random photograph; it is real, or it is a labelled slot listed in the report. `[ASSET-SUBJECT]`

## Content and copy

- [ ] Every section is a short headline plus a short paragraph plus one asset or one action. `[CONTENT-SECTION]`
- [ ] No data dump on a marketing surface. `[CONTENT-NODUMP]`
- [ ] Testimonials fit in a glance, with clean attribution. `[CONTENT-QUOTE] [COPY-ATTRIBUTION]`
- [ ] Every number is real or visibly labelled as sample data. `[CONTENT-NUMBERS] [COPY-AUDIT-METRIC]`
- [ ] One register runs through the page. `[CONTENT-REGISTER]`
- [ ] Every visible string was re-read, with no broken grammar, dangling referent, mock-poetic phrasing, or performed craft. `[COPY-AUDIT-GRAMMAR] [COPY-AUDIT-REFERENT] [COPY-AUDIT-MOCK] [COPY-AUDIT-CRAFTSMAN]`
- [ ] Zero em dashes and zero separator en dashes in visible strings. `[COPY-EMDASH]`
- [ ] Quotation marks are typographic or absent. `[COPY-QUOTES]`
- [ ] No invented person, brand, or testimonial, and no placeholder names from the first examples a model recalls. `[COPY-PLACEHOLDERS]`
- [ ] Alternative text describes what the image contributes rather than repeating the caption. `[COPY-ALT]`

## Consistency and honesty

- [ ] One design system, one icon family, one accent, one radius system, one theme, one motion vocabulary. `[DEFAULT-MIXDS] [DEFAULT-MIXICONS]`
- [ ] Colour comes from semantic tokens, not from hex values written into components. `[AX-TOKENS]`
- [ ] The page has a title, a description, a share card, and a favicon, all written in the language of the page. `[META-TITLE] [META-DESCRIPTION] [META-SHARE] [META-ICON]`
- [ ] The performance floor holds: modern image formats, reserved space, prioritised hero asset, deferred third-party scripts, and a cumulative layout shift under 0.1. `[PERF-CWV] [PERF-ASSETS]`
- [ ] Fonts swap and reserve space, only critical faces are preloaded, and no render-blocking third-party font link is shipped. `[PERF-FONTS]`
- [ ] High-frequency events are throttled, long lists are virtualised, and the slow and offline states are designed. `[PERF-EVENTS] [PERF-LISTS] [PERF-DEGRADED]`
- [ ] Code splits by route, per-frame work is batched, and nothing heavy sits in the initial payload. `[PERF-BUNDLE] [PERF-MAINTHREAD]`
- [ ] Nothing was claimed that was not verified: no unticked box reported as passed, no check reported as run when it was skipped, no metric, logo, credit, or testimonial invented. `[SKILL.md guardrails]`
- [ ] No detected stack, URL slug, navigation label, form field name, brand mark, or legal copy was changed silently. `[RD-FROZEN]`

## Verdict

- [ ] All boxes above are ticked.
- [ ] One sentence states why this could only have been made for this subject, and it is specific enough that a neighbouring brief would have produced a different answer.
- [ ] Any box that could not be ticked, any check that was skipped, and any confirmed false positive are named in the report.
- [ ] The report ends with the direction record, the three magnitudes, the plan, what the plan review changed, and the pre-flight result.
