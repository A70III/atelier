# Build Discipline

The rules that decide whether a page that looks good in a screenshot survives contact with a
browser, a phone, and a keyboard.

## Stack

**`STACK-DETECT`** Read the project before choosing anything: `package.json`, or `pubspec.yaml`,
`composer.json`, `*.xcodeproj`, `Package.swift`, and the config files. Use what is already there,
and never swap a detected stack silently.

**`STACK-DEFAULT`** When nothing is detectable, say so and default to React or Next with Tailwind
and Motion, rather than letting the assumption pass as a decision. Two stated exceptions: a static
site with no build step and no project around it is plain HTML, CSS, and only the JavaScript the
magnitudes actually require, and a run whose `MOTION` sits at 1 or 2 needs no JavaScript at
all.

**`STACK-DOCS`** Follow the installed version's own documentation for configuration and plugin
shapes. Do not assume a config layout from memory, and do not pin a version the project has not
chosen.

**`STACK-DEPS`** Confirm a dependency exists in the project before importing it. When it is missing,
name the package that is needed instead of assuming the import resolves.

## Layout mechanics

**`LAYOUT-BREAKPOINTS`** Use one systematic set, for example 640, 768, 1024, 1280, 1536. Do not
invent a breakpoint mid-page.

**`LAYOUT-CONTAINER`** Contain the page in a shared maximum width, centred, with gutters that grow
on larger screens.

**`LAYOUT-VIEWPORT`** Size a full-height section with the dynamic viewport unit (`100dvh`), not
`100vh`. The static unit ignores mobile browser chrome and makes the layout jump as the address bar
hides.

**`LAYOUT-GRID`** Use CSS Grid for columns. Percentage flex arithmetic (`w-[calc(33%-1rem)]`) is a
sign the layout was not thought through.

**`LAYOUT-MOBILE`** Declare the below-768px collapse inside the same component as the multi-column
layout. Assume nothing. Every asymmetric composition ends as a single column, full width, with
modest horizontal padding.

**`LAYOUT-NOSCROLL`** No horizontal scrolling on mobile. Check the widest element, including
overflowing labels, long tokens, and tables.

**`LAYOUT-ZINDEX`** Define one z-index scale for the project (for example 0, 10, 30, 60, 120, 240)
and use it for real layers only: sticky navigation, overlays, modals, grain. Do not scatter
arbitrary high values.

**`LAYOUT-NESTED-SCROLL`** One scroll region per page. Nested scroll containers fight the page and
trap touch users.

## Hero

**`HERO-FITS`** The hero fits the first viewport. Headline at most two lines on desktop, subtext
under about twenty words and at most four lines, and the primary action visible without scrolling.
If it does not fit, the font scale is wrong or the copy is too long. Cut one of them.

**`HERO-SCALE`** Plan the font size and the asset size together. A hero with a large asset and a
long headline does not start at the largest display size. A four-line headline is a scale error,
not a copy error.

**`HERO-PADDING`** Cap top padding at roughly six rem on desktop. Past that the hero reads as a
layout mistake: the content ends up hanging in the middle of the viewport with a band of dead space
above it. If the hero needs air, grow the type or the asset, not the padding.

**`HERO-STACK`** At most four text elements: an optional small label or brand strip, the headline,
the subtext, and one primary action with at most one secondary. Nothing else belongs in the hero.
Trust strips, taglines under the buttons, pricing teasers, feature bullets, avatar rows, and logo
walls go in their own section directly below.

**`HERO-VISUAL`** A hero with type and a gradient blob is a placeholder. It carries a real image, a
generated image, a genuine component preview, or a deliberate typographic composition that is the
visual.

## Navigation

**`NAV-ONELINE`** The navigation occupies a single line on desktop. When the items will not fit,
shorten the wording, cut the least important links, or collapse the set behind a menu.

**`NAV-HEIGHT`** Cap the bar at about 80px desktop, with 64 to 72px as the common case. A bar that
eats a sixth of the viewport is a design bug.

**`NAV-FIXED`** When the bar is fixed, reserve the space it covers so content is never hidden
beneath it.

## Composition

**`COMP-VARIANCE`** Express `ASYMMETRY` through concrete devices: offset a block, vary two
aspect ratios against each other, let one element break the container, leave a large empty zone.
Symmetry is a choice at low values, not a fallback.

**`COMP-CENTER`** A centred hero is refused above `ASYMMETRY` 3, except for editorial, manifesto, or
launch briefs in which the wording itself is the visual.

**`COMP-REPEAT`** A layout family appears at most once per page. Three-column cards, a full-width
quote, and a split text-and-image block are three families; a page with eight sections uses at
least four of them.

**`COMP-ZIGZAG`** At most two consecutive sections that alternate image and text across the width.
A third one is a failure. Break the run with a section that spans the full width, a stacked block,
a grid, or a marquee.

**`COMP-CARDS`** A card is justified only where the raised surface encodes a real hierarchy.
Everywhere else, group with a single rule, a divider between items, or negative space. `DENSITY` 5
removes generic card containers entirely.

**`COMP-SHADOW`** Tint a shadow toward the background hue. A pure black drop shadow on a light
surface reads as a template.

**`COMP-SHAPE-LOCK`** Choose one corner-radius system and keep it. Either everything sharp,
everything soft, or everything pill, or a documented rule such as buttons pill, cards 16, inputs 8,
applied everywhere.

**`COMP-THEME-LOCK`** One theme for the page. A dark page has dark sections; a light page has light
sections. Tints within the family are fine. What is not fine is the reader walking into a different
site halfway down. One deliberate, transitioned theme switch is allowed once, and only when the
brief asks for that device.

**`COMP-NOHEADER-SPLIT`** A section header is one message. A large headline with a small explainer
paragraph floating in the opposite column is refused as a default. Stack them, or give the second
column something real to carry.

**`COMP-EYEBROW`** At most one eyebrow label per three sections, counting the hero as one. A page
of nine sections may use three. Count the instances mechanically before shipping, and when in
doubt, drop the label: the headline alone is enough, and position already categorises the section.

**`BENTO-RHYTHM`** A bento grid changes its composition as it goes rather than repeating one row
shape. A wide feature row, then tiles of unequal size, then a vertical break.

**`BENTO-COUNT`** Cell count and content count are the same number. Three items fill three cells;
five fill five. A blank cell, wherever it falls, means the shape was chosen before the content was
counted: reshape the grid instead of pasting a filler tile.

**`BENTO-VARIATION`** In any multi-cell grid, at least two or three cells carry real visual
variation: an image, a subject-appropriate gradient, a pattern, or a tinted surface. A grid of
identical white cards with text inside is dull even when everything around it is good.

**`LIST-COMPONENT`** At six or more items, a plain list is the lazy answer. Group into two columns, use a
card per item, use tabs or an accordion when items are categorisable, scroll-snap through pills, or
let a carousel or marquee carry breadth.

**`LIST-SPEC`** For hardware, apparel, and artisan goods the habitual answer is one long table with
a rule between every row. Restructure instead: a two-column card per specification
with the value set large and a one-line reason it matters, or scroll-snap pills, or three logical
clusters each with one soft divider, or three or four featured specifications with the rest behind
a disclosure.

**`LIST-MARQUEE`** At most one marquee per page. A second one reads as filler.

## States

**`STATE-LOADING`** Loading skeletons match the shape of the layout they are replacing. A generic
circular spinner in the middle of a page is a missed opportunity.

**`STATE-EMPTY`** An empty state is composed, not blank, and it says how to fill it.

**`STATE-ERROR`** Errors appear inline for forms and contextually for transient failures. A toast is
for something that has already been acknowledged, not for the only copy of an error message.

**`STATE-A11Y-REF`** Contrast, focus, target size, semantics, form behaviour, navigation, and
charts are specified in `accessibility-ux.md`. Read it while building, not afterwards. That file
is the single source for those rules, and it wins when it conflicts with a visual idea.

## Actions and forms

**`CTA-ONELINE`** A button's label stays on a single line at desktop width. If it wraps, either
shorten the wording or stop holding the button to a narrow width. Contrast, hit area, and label
readability for that button are specified in `accessibility-ux.md`.

**`CTA-INTENT`** One label per intent per page. "Get in touch", "Contact us", and "Let's talk" are
one intent; pick one and use it in the navigation, the hero, and the footer.

**`FORM-LAYOUT`** Label above the input, helper text where it earns its place, error text below the
input, and one consistent gap inside the block. Validation timing, error association, error
summaries, and input types are specified in `accessibility-ux.md`.

## Images and assets

**`ASSET-ORDER`** In priority order: generate the image if an image tool exists; otherwise use real
photography from a licence-clear source or a seeded placeholder service with a descriptive seed;
otherwise leave a labelled placeholder slot and list the placements when you report back.

**`ASSET-NOFAKE`** A product preview built from styled rectangles is the most recognisable sign of
generated design. Show a captured screenshot, a generated image, an actual miniature of the
component, or nothing.

**`ASSET-LOGOS`** A trust wall uses real brand marks from a maintained icon source, or a generated
monogram when the brand is invented. A plain-text wordmark for a brand that does not exist yet reads
as a placeholder nobody finished.
Logos render in both themes, and the wall contains logos only: no industry label under each mark.

**`ASSET-SVG`** Icons come from an icon library. A hand-rolled decorative SVG is refused as a
default, and is allowed only when the brief asks for a drawn mark or the mark is one simple
geometric form you are confident in.

**`ASSET-DECOR`** A page with no imagery at all is incomplete, not minimal. Decorative and
atmospheric work, such as a texture band, a material study, or an atmosphere shot, uses real
photography or generated imagery. A subject-agnostic texture is the one place a placeholder service
belongs.

**`ASSET-SUBJECT`** An image whose subject carries meaning, such as a product shot, a cover, a
portrait, or a place, is never stood in for by a random photograph. Where the real asset does not
exist, leave a labelled slot with its intended dimensions and list it when you report back. A
stock landscape standing in for a book cover misrepresents the book, which is worse than an empty
frame.

**`ASSET-PLATE`** A printed artefact that does not exist yet is a separate case from a screenshot.
A book cover, a poster, or a label may be set typographically as the design's own proposal, in the
page's own type and palette, because that is a real object rather than a picture of one. Say in the
markup that it is a proposed plate, so it is replaced when the artwork arrives, and keep it out of
the fake-screenshot category by never implying that it is a photograph of the finished thing.

## Content density

**`CONTENT-SECTION`** A section is a short headline, a short supporting paragraph, and one asset or
one action. Beyond that, each addition has to earn its place by what the section is for.

**`CONTENT-NODUMP`** Twenty-row tables, thirty-item award lists, and full pricing matrices do not
belong on a marketing page. Show the top few, then a link, a carousel, a marquee, or a different
page.

**`CONTENT-QUOTE`** A testimonial fits in a glance: at most three lines of quote, attribution with
name and role, real typographic quotation marks. A quote that needs six lines gets cut.

**`CONTENT-NUMBERS`** Every number either comes from real data or is visibly labelled as sample
data. Invented precision is refused: a specification the brand does not claim is a lie with a
decimal point.

**`CONTENT-REGISTER`** One voice per page. Technical mono, editorial prose, and marketing urgency
do not share a composition unless the brand's own voice already mixes them.

## Page metadata

**`META-TITLE`** One title per page, written for the person reading a search result or a browser
tab. It names the subject rather than the site, and it is not a chain of separator dashes.

**`META-DESCRIPTION`** A description that says what the page is and who it is for, written in the
language of the page.

**`META-SHARE`** A share card: at minimum a title, a description, and a type, plus an image where
one exists. A page that lands in a chat window as a bare URL is unfinished, and the same card is
what a search engine and a social platform will show.

**`META-ICON`** A favicon. A tab showing the browser's default document glyph reads as abandoned.

## Performance floor

**`PERF-CWV`** Target a largest contentful paint under 2.5 seconds, an interaction latency under
200 milliseconds, and a cumulative layout shift under 0.1. The hero image is prioritised or
preloaded, and space is reserved for images, fonts, and embeds.

**`PERF-ASSETS`** Serve images in a modern format, at responsive sizes, and lazy-load everything
below the fold. Declare width and height or an aspect ratio so the space is reserved before the
image arrives.

**`PERF-FONTS`** Self-host fonts or use the framework's font loader with swap, and reserve space for
them. Preload only the critical faces, and ship no render-blocking third-party font link.

**`PERF-BUNDLE`** Prioritise above-the-fold CSS, split non-critical components by route, and
lazy-load anything below the fold. Third-party scripts are deferred, audited, and removed when they
earn nothing. A heavy animation or 3D library does not belong in the initial payload.

**`PERF-MAINTHREAD`** Keep per-frame work under about 16 milliseconds. Batch layout reads and
writes, and move heavy computation off the main thread.

**`PERF-EVENTS`** Throttle or debounce high-frequency events such as scroll, resize, and input.

**`PERF-LISTS`** Virtualise lists beyond roughly fifty items.

**`PERF-GRAIN`** A grain or noise overlay lives on a fixed, pointer-events-none element. Never on a
scrolling container, where it forces a repaint every frame.

**`PERF-DEGRADED`** Design the slow and offline states: reduced imagery, fewer animations, and an
explicit offline message with a fallback.

Animated properties are owned by `interaction-motion.md` (`MOTION-HARDWARE`): transform and opacity
only, with `will-change` used sparingly and removed afterwards.
