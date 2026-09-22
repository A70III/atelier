# Interaction and Motion

Motion is the easiest place to look competent and the easiest place to look generated. The
difference is never the amount of motion, it is whether each animation answers a question.

Reduced motion is a requirement, owned by `accessibility-ux.md` (`MO-REDUCED`). Every mechanism
below has to satisfy it, and anything above a subtle intensity collapses to its static final state.

## Principles

**`MOTION-MOTIVATED`** Before adding an animation, answer in one sentence what it communicates.
Valid answers: hierarchy (pointing the eye at what matters), storytelling (unfolding content in
the order it should be understood), feedback (acknowledging an action), or state change (showing
that something became something else). "It looked good" is not an answer. Drop the animation.

**`MOTION-CLAIMED`** If `MOTION` is above 3, the page moves: an entry transition, a reveal on
the key sections, feedback on the primary actions. A still page claiming 5 is
broken. If the scope cannot carry working motion, lower `MOTION` and ship a confident still page.
Half-built motion, with cut-off triggers and missing cleanups, is worse than none.

**`MOTION-ONCHANGE`** If an animation cannot be justified but the element still needs to appear,
animate opacity and a small transform, which the eye reads as arrival rather than as decoration.

**`MOTION-HARDWARE`** Animate `transform` and `opacity` only. Width, height, top, left, and
margin animate layout and must not be animated, in CSS or in a library.

**`MOTION-TIMING`** Use one shared set of durations and easings for the project. Decelerate when
arriving, accelerate when leaving, and use linear only for genuinely constant motion such as a
spinner or a progress bar. Exit faster than entry, around two thirds of the entry duration.

**`MOTION-STAGGER`** Stagger revealed items by roughly 30 to 60 milliseconds each. One deliberate
sequence on load reads better than effects sprinkled across every card.

**`MOTION-INTERRUPT`** Motion never blocks input, and it is interruptible: a tap or a gesture
cancels an in-flight animation immediately. State correctness never depends on an animation
completing. Rapid state changes cancel the previous interaction cleanly and land on the new end
state directly.

**`MOTION-RESTRAINT`** One or two animated elements per view. Motion on every card in a grid reads
as noise. One marquee per page, and only where horizontal breadth actually serves the content. A
pulse, a float, or a shimmer does not loop on every element: an infinite loop belongs on a live
indicator, and a section that is informational stays still.

**`MOTION-CONTINUITY`** Navigation and state changes keep spatial continuity: a forward transition
moves in one direction, backward moves in the other, and a shared element travels rather than
cross-fading in place.

## Mechanisms

| Need | Use |
|---|---|
| Component state, layout changes, entrance reveals | The Motion library, in a client component |
| Pinning, scrubbing, horizontal pan, sequenced storytelling | A scroll-trigger library, isolated in its own leaf component |
| Canvas, 3D, heavy atmospheres | A WebGL library, loaded lazily and isolated |
| "Appear when it enters the viewport" | The framework's in-view helper, or an intersection observer |
| Scroll-linked effects without JavaScript | CSS scroll-driven animations |

**`MOTION-ISOLATE`** Any component that animates, listens for scroll, or tracks the pointer is an
isolated leaf marked as a client component, with its animation set up in an effect that returns a
cleanup. Static layout stays in the server-rendered tree.

**`MOTION-NOMIX`** Never run a scroll-trigger library or a WebGL library alongside the Motion
library inside one component tree. Two of them competing for the same frames produces jitter that
no amount of tuning fixes.

**`MOTION-BANNED`**

- `window.addEventListener('scroll', ...)` and scroll or resize handlers that touch layout on every frame.
- Reading `window.scrollY` into component state.
- Animation-frame loops that set React state.
- Animation layout props wrapped around static content.
- Any animated property that triggers layout.

## Scroll behaviour

Three shapes cover nearly every brief: items arriving as they enter the viewport, a section held
still while its own content advances, and vertical scroll driving a horizontal rail. Build only the
shapes the brief asks for.

**`MOTION-REVEAL`** The default arrival. Items become visible once, as they cross into the
viewport, and never animate again. The animation does not reverse on exit, and does not re-run when
the reader scrolls back up.

**`MOTION-PIN`** A section holds position while its own content advances. Reach for it only when
the content genuinely needs the reader's attention held, because for the length of the pin it takes
control of the scroll away from them.

**`MOTION-RAIL`** Vertical scroll moves content sideways. Reach for it only when the content is a
true sequence whose order matters, never to make a row of unrelated cards more interesting.

### The settings that carry these shapes

The bugs live in the values, not in the library. These are the load-bearing ones.

| Setting | Reveal | Pin | Rail |
|---|---|---|---|
| Trigger opens when | the element is roughly a third into the viewport | the pinned element's top edge meets the viewport top edge | same as pin, on the section wrapper |
| Trigger closes when | not applicable, it fires once | derived from the last child, so the pin ends when the sequence does | derived from the horizontal overflow distance, so scroll length equals travel |
| What gets pinned | nothing | the wrapper, not the moving child | the wrapper |
| Scrub | no | none: the pin holds while the children animate | a small smoothing value, around 1, never 0 |
| Recompute on resize | no | yes | yes |
| Cleanup | disconnect the observer | revert the context, or a reload stacks duplicate triggers | same |

Three of these break in production more often than the rest:

- **Where the pin opens.** A trigger that opens partway down the viewport makes the section jump
  the moment the pin engages. It opens when the two edges meet.
- **Where the pin closes.** An end written as a fixed pixel height desynchronises from the content
  as soon as a font loads or the text reflows. Derive it from the element that ends the sequence.
- **Recomputation after resize.** Both the pin and the rail measure the document once, at setup.
  Without a recompute they are wrong after a resize, a rotation, or a late font.

### Reveal without a library

Prefer this shape. It needs no dependency, survives a re-render, and cannot fight another library
for frames.

```css
.reveal {
  animation-name: rise;
  animation-timing-function: linear;
  animation-fill-mode: both;
  animation-timeline: view();
  animation-range: entry 15% cover 35%;
}
@media (prefers-reduced-motion: reduce) {
  .reveal { animation: none; opacity: 1; transform: none; }
}
@keyframes rise {
  from { opacity: 0; transform: translateY(1.5rem); }
  to   { opacity: 1; transform: none; }
}
```

No duration is declared: with a scroll timeline the scroll position is the clock. Where scroll-driven
animation is unsupported, an intersection observer that toggles a class is the fallback, and an
element that receives neither treatment is simply visible. A staggered version adds a delay per
child, capped so the last one trails the first by no more than about a third of a second.

**`MOTION-RAILSCROLL`** A horizontal rail must never be the only way to reach its content. Keyboard
focus moves through it, and the pointer wheel over it scrolls it natively. Anything that traps
scroll is a defect, not an effect.

## Feedback

**`MOTION-PRESS`** Press feedback arrives within about 100 milliseconds and uses colour, opacity,
or a small scale. The requirement that it exists and does not move its neighbours is owned by
`accessibility-ux.md` (`UX-PRESS`).

**`MOTION-LOADING`** A button that starts async work disables itself and shows progress on the
button, not somewhere else on the page. Match the indicator to the expected wait: a skeleton for
content, a spinner for a short action.

**`MOTION-GESTURE`** A drag, swipe, or pinch tracks the pointer in real time and shows where the
release will land. Provide a visible control for anything critical: gesture-only interactions are
unusable for a large part of the audience.

