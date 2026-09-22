# Accessibility, Interaction, and Responsive Rules

This is the rule set that wins when it conflicts with a visual idea. Contrast, focus, target size,
and semantics are not design preferences: they decide whether the page works.

Read the priority index first, then the rules for the categories the work touches.

| Priority | Category | Impact | The must-haves | The anti-patterns |
|---|---|---|---|---|
| 1 | Accessibility | Critical | 4.5:1 text contrast, alt text, keyboard operation, visible focus, accessible names | Focus outlines suppressed, unnamed icon-only controls |
| 2 | Touch and interaction | Critical | 44px comfortable targets with a 24px floor, 8px separation, loading feedback | Hover-only affordances, no press feedback |
| 3 | Performance | High | Modern image formats, lazy loading, reserved space, shift under 0.1 | Layout thrashing, content that jumps |
| 4 | Style consistency | High | One style across pages, icons from one family, effects that match the style | Emoji as icons, mixed visual languages |
| 5 | Layout and responsive | High | Viewport meta, mobile-first breakpoints, no horizontal scrolling | Fixed pixel containers, disabled zoom |
| 6 | Typography and colour | Medium | 16px body, line height 1.5 or more, semantic colour tokens | Body text under 12px, raw hex in components |
| 7 | Animation | Medium | Motion that states a cause and effect, shared timing tokens, reduced-motion support | One duration reused everywhere, animated layout properties |
| 8 | Forms and feedback | Medium | A visible label per field, errors placed next to it, an explanatory note where the field needs one | The placeholder standing in for a label, errors collected only at the top |
| 9 | Navigation | High | Predictable back, five or fewer bottom items, deep links, an indicated current location | Overloaded navigation, silent resets |
| 10 | Charts and data | Low | Legends, tooltips, accessible colours, a table alternative | Colour as the only encoding |

## Contrast and colour

**`AX-CONTRAST`** Normal text clears 4.5:1 against its own background. Large text, meaning roughly
24px or 18.7px bold, clears 3:1. Aim higher for hero copy. Measure the composed result, not the
intended one: a gradient, a scrim, or a translucent panel changes the real background.

**`AX-NONTEXT`** Non-text elements that carry meaning clear 3:1: icon glyphs, input borders, focus
indicators, chart lines, and the boundaries of interactive controls.

**`AX-COLORONLY`** Colour is never the only signal. Error and success states carry an icon or text
as well. Charts use pattern, shape, or direct labels alongside hue.

**`AX-DARKMODE`** Dark mode is designed from the start and tested on its own, for every page,
print-emulating editorial included. There is no opt-out. The dark variant is the same material seen
under different light: it keeps the brand, the hierarchy, and the accent, uses lighter and
desaturated tonal variants rather than inverted light values, and is measured separately because
light-mode ratios do not carry over. Separators, pressed states, and focused states stay legible in
either theme.

**`AX-TOKENS`** Colour comes from semantic tokens mapped per theme, not from hex values written into
components. One strategy per project: either the framework's dark variant on every colour utility,
or CSS custom properties swapped under the theme.

**`AX-ZOOM`** Text scales to two hundred percent without loss of content or function. Nothing
truncates or clips as the system text size grows, and zoom is never disabled in the viewport meta.

**`AX-REFLOW`** The page reflows to a 320px viewport without two-dimensional scrolling. Long tokens
such as URLs and identifiers wrap with `overflow-wrap: anywhere` on a shrinkable text child, never
with `break-all` on normal prose.

## Keyboard, focus, and assistive technology

**`AX-KEYBOARD`** Every interactive element is operable by keyboard, in an order that matches the
visual order. Custom controls receive focus, expose their role and state, and respond to Enter and
Space as the native control would.

**`AX-FOCUS`** Focus is always visible: a ring of two to four pixels, at 3:1 against what is behind
it, not removed for aesthetics. A focused control is never entirely hidden behind sticky headers,
footers, banners, or overlays.

**`AX-FOCUS-TRACK`** Focus moves to the main content region after a route change, and into a dialog
when it opens, returning to the trigger when it closes.

**`AX-LANDMARKS`** Structure is exposed: one main region, a skip link to it, one heading level one,
and a heading order with no skipped levels. Sections that are visually labelled are programmatically
labelled.

**`AX-NAMES`** Every control has an accessible name. Icon-only buttons get a label. An icon that
sits beside text and adds nothing is kept out of the accessibility tree, while a standalone icon
that carries meaning gets a text alternative. State such as selected, pressed, or expanded is
exposed where it applies.

**`AX-ALT`** Meaningful images carry a description of what they contribute, not of their format.
Decorative images are hidden. Complex imagery has a longer alternative nearby.

**`AX-STATUS`** A changed count or status is announced as a complete phrase through a single polite
status region, without moving focus. Keep the region's updates atomic and its content meaningful on
its own.

**`AX-HELP-CONSISTENCY`** Repeated help mechanisms, such as a contact link or a chat entry, appear in
the same relative place across the pages of a set.

**`AX-REDUNDANT-ENTRY`** Anything the person has already given in this flow is carried forward
instead of being asked for a second time, unless re-entry is genuinely required.

**`AX-AUTH`** Authentication permits password managers and pasting, and offers a route that does not
rely on solving a cognitive puzzle.

**`AX-SHORTCUTS`** Single-character keyboard shortcuts can be turned off, remapped, or are active
only while the control has focus. Platform and assistive shortcuts are never intercepted.

**`AX-DRAG-ALT`** Every drag interaction has a single-pointer and a keyboard alternative.

**`AX-ROTATION`** Auto-rotating or auto-moving content offers a pause or stop control, halts while
it holds focus, and halts again under reduced motion.

**`AX-ESCAPE`** A dialog or a multi-step flow always offers a way out: a visible close, a cancel, or
the platform's standard dismissal.

## Targets and touch

**`UX-TARGET`** Interactive targets are at least 24 by 24 CSS pixels, and comfortably 44 by 44. When
the visible glyph is smaller than the target, expand the hit area rather than growing the artwork.

**`UX-TARGET-GAP`** Keep at least 8px between adjacent targets so a near miss does not trigger the
neighbour.

**`UX-NOHOVERONLY`** Anything reachable by hover is also reachable by tap and keyboard. Hover is an
enhancement, never the only way to reveal information or an action.

**`UX-PRESS`** Every tappable element responds visibly to press. The feedback does not move
surrounding content.

**`UX-SCROLL-HIJACK`** Horizontal swipe on the main content is avoided. Vertical scrolling stays
under the browser's control, with `touch-action: manipulation` to drop the tap delay.

**`UX-GESTURE-STD`** Platform gestures, such as back-swipe and pinch-zoom, are never blocked or
redefined. Where a swipe carries an action, the affordance is visible before the gesture.

**`UX-NO-PRECISION`** No interaction requires a pixel-accurate hit on a thin edge or a small icon.

## Forms and feedback

**`FM-LABELS`** Every field has a visible label associated programmatically with the control. A
placeholder never replaces the label.

**`FM-HELP`** Persistent helper text sits below a field that needs explanation, not only in a
placeholder. Required fields are marked in text, not by colour alone.

**`FM-ERRORS`** An error appears next to the field it concerns, states the cause and the fix, and is
connected to the field for assistive technology. Errors are not summarised only at the top.

**`FM-SUMMARY`** After a failed submit with several errors, a focusable summary appears at the top,
each entry links to its field, and the inline errors remain. A single error takes focus to its
field.

**`FM-LIVE`** Errors and status announcements reach assistive technology through a live region or an
alert role, without stealing focus. Toasts are announced politely and never hold the only copy of a
message.

**`FM-VALIDATE-TIME`** Validation runs when the field loses focus, not on every keystroke, and the
message appears after the person has finished rather than while they are typing.

**`FM-INPUT-TYPE`** Fields use semantic input types so the correct mobile keyboard appears, and
autocomplete attributes so the browser and password managers can fill them.

**`FM-SUBMIT`** Submitting shows progress, then success or failure, in place. A timeout is reported
with a retry.

**`FM-DESTRUCTIVE`** Destructive actions are visually separated, use the danger colour, and offer
confirmation or undo. Legal, financial, and data-destroying actions are reversible or confirmed.

**`FM-PROGRESSIVE`** Complex options are revealed progressively rather than all at once. Long forms
save drafts so an accidental dismissal does not lose work.

**`FM-DISABLED`** Disabled controls use native disabled semantics, reduced emphasis, and no
pointer response. Read-only is visually and semantically distinct from disabled.

## Navigation

**`NV-STATUS`** The current location is visibly indicated in the navigation, and navigation sits in
the same place on every page.

**`NV-HIERARCHY`** Primary destinations and secondary destinations are clearly separated. Different
navigation patterns at the same level are mixed only deliberately.

**`NV-BOTTOM`** A bottom bar holds at most five top-level destinations, each with an icon and a
label. Sub-navigation never nests inside it.

**`NV-BACK`** Back behaves predictably and restores prior scroll position, filters, and input.
The navigation stack is never silently reset or jumped to home.

**`NV-DEEPLINK`** Every key screen is reachable by URL, so it can be shared and opened from a
notification. A destination that is unavailable is explained rather than silently hidden.

**`NV-BREADCRUMB`** On the web, a hierarchy three levels deep or more carries breadcrumbs.

**`NV-BADGE`** Badges on navigation items are reserved for genuine pending state and clear after the
destination is visited.

**`NV-OVERFLOW`** When actions exceed the space, they move into an overflow menu rather than
crowding, and navigation is never hidden entirely on a deep page.

## Responsive layout

**`RESP-META`** The viewport meta is present with `width=device-width, initial-scale=1`, and zoom is
not disabled.

**`RESP-MOBILEFIRST`** Layouts are designed from the smallest viewport upward, with content
prioritised so the core appears first and secondary content folds.

**`RESP-TEXT`** Body text is at least 16px on mobile, partly to prevent the browser's automatic
zoom-on-focus, and line length stays between about 35 and 60 characters on mobile and 60 and 75 on
desktop.

**`RESP-SCALE`** Spacing comes from an incremental scale, in 4 and 8 unit steps, rather than from
values chosen per component.

**`RESP-ORIENTATION`** The layout stays readable and operable in landscape.

**`RESP-FIXED`** Fixed headers, footers, and action bars respect the safe areas of the device and
reserve the space they cover.

**`RESP-LABEL-OVERFLOW`** Pick the control from what the value means, since a status tag, a filter
chip, a removable token, and a badge each carry different semantics. Essential labels stay
available, and unavoidable truncation is disclosed for both pointer and keyboard users through a
disclosure that exposes the full value. A chip collection wraps before its labels shrink.

## Motion accessibility

**`MO-REDUCED`** Reduced motion is honoured for everything above a subtle level. Infinite loops,
parallax, scroll hijacking, and pointer physics resolve to their static final state.

**`MO-NOBLOCK`** Motion never blocks input or delays a task. Every animation is interruptible by the
user, and correctness never depends on an animation-end event.

**`MO-SHIFT`** Animation never causes layout shift. Position changes use transforms.

**`MO-OPACITY-FLOOR`** A fading element does not linger half-visible below an opacity of about 0.2.
It either fades out or stays.

## Performance

Performance is specified once, as build rules, in `build-discipline.md`, section *Performance
floor*. It stays priority 3 in the index above because it is felt by the person using the page,
whatever the page looks like.

## Charts and data

**`CH-TYPE`** The chart type follows the data: a line for trend, bars for comparison, a donut for a
proportion of a few parts. More than five categories does not become a pie.

**`CH-ACCESS`** Colour is never the sole encoding. Palettes are distinguishable for colour-vision
deficiency, data against background clears 3:1, and labels clear 4.5:1.

**`CH-ALTERNATIVE`** A chart has a text summary of its key insight, and data is available as a
table. A sortable table exposes its sort state and supports keyboard sorting.

**`CH-LEGEND`** The legend sits with the chart and is never stranded past the fold. Small datasets
are labelled directly.

**`CH-INTERACT`** Tooltips are reachable by keyboard and by tap, not by hover alone. Interactive
points and bars are focusable and large enough to hit.

**`CH-AXES`** Axes carry units and readable ticks with automatic skipping on small screens. Numbers,
dates, and currencies are formatted for the locale.

**`CH-DENSITY`** Information density per chart is limited, grid lines stay low-contrast, and
decoration that obscures the data is removed. Above a thousand points, aggregate or sample, with a
drill-down for detail, and keep a clear back path.

**`CH-STATES`** A chart has a loading skeleton, a meaningful empty state, and an error state with a
retry, rather than an empty axis frame or a broken canvas. Entrance animation respects reduced
motion, and the data is readable immediately.
