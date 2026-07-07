# Animation Conventions

Animation is explanation, not reward. The default is no animation; move only when, without motion, the user would lose the causality of a change. When you do move, pick from the team's palette, keep it short and smooth, and never block the software's immediate response.

## Rules

**1. The default is no animation. Add motion only when it explains a change, and only as much as its frequency allows.**

Ask twice before adding an animation:

- **What does this motion explain?** If the user loses nothing when the transition happens without motion, do not add it. The legitimate answers are causality and continuity: what triggered this change (the popover grows out of the button that was pressed), what came from where and went where (the item slides out of the list), where am I now (the panel pushes in from the side). "It would look nice" is not an answer.
- **How often is it encountered?** Frequency sets the budget. 300ms on a menu opened 200 times a day is six hours a year. The more frequent the interaction, the shorter or absent the motion, and long production numbers are reserved for moments that matter exactly once (onboarding, celebration).

Typical violations: entrance effects replayed every time data appears, staggers across every card on the page, delays on micro-interactions like hover.

```tsx
// Bad: decoration that explains nothing. The same show replays every time the list is viewed
<Card className="animate-in fade-in slide-in-from-bottom-4 duration-500">…</Card>

// Good: content appears immediately
<Card>…</Card>
```

**2. The kind, length, and easing of motion come from the team's palette. Do not invent new motion in the field.**

- **Kind**: fade (opacity), scale (size), slide (position), and their combinations are the palette. Bouncing and wobbling are outside it.
- **Length**: proportional to the size of the motion. Micro-interactions run 100 to 200ms, element entrances and exits around 200ms, and even screen-level transitions never exceed 300ms. Exits are shorter than entrances.
- **Easing**: entrances decelerate (ease-out); they should be almost there the moment they start. Exits accelerate or simply disappear. linear is only for endless repetition, like spinners.

```tsx
// Bad: motion outside the palette, and a toast longer than a screen transition
<Toast className="animate-bounce-in duration-700">…</Toast>

// Good: a small entrance needs no more than fade plus slide
<Toast className="animate-in fade-in slide-in-from-bottom-2 duration-200">…</Toast>
```

**3. Duration and easing values are defined in one token scale. No raw numbers at call sites.**

A new ms number or cubic-bezier in a diff is a violation. If the motion you need is not in the scale, add a name to the scale, then use it. This layer owns more than consistency: it owns `prefers-reduced-motion`. When every animation passes through the tokens and shared primitives, reduced motion is a switch in one place, not something call sites have to remember.

```tsx
// Bad: values invented in the field. Every file gets its own rhythm, and reduced motion silently goes missing
<Popover style={{ transition: "opacity 237ms cubic-bezier(0.17, 0.67, 0.83, 0.67)" }}>…</Popover>

// Good: the call site knows only the scale's names
<Popover className="transition-opacity duration-fast ease-out">…</Popover>
```

**4. Choose the implementation in the order CSS transition → CSS animation → script, and restrict animated properties to transform and opacity.**

Interpolation between two states is a transition; repetition unrelated to state (spinner, skeleton) is an animation; script-driven motion is only for what CSS cannot express (continuity between elements, gesture following). Animating width, height, top, or margin recomputes layout every frame. Draw the same result with transform.

```tsx
// Bad: animates a layout property. Layout is recomputed every frame
<Sidebar className="transition-[width] duration-fast" style={{ width: isOpen ? 280 : 0 }}>…</Sidebar>

// Good: transform draws the same motion
<Sidebar
  className={cn(
    "transition-transform duration-fast",
    isOpen ? "translate-x-0" : "-translate-x-full",
  )}
>
  …
</Sidebar>
```

**5. Facts do not wait for animation. State changes, navigation, and requests know nothing about an animation's completion.**

Facts commit immediately in the event handler; animation is a presentation that follows the committed fact. Exit animations are no exception. Closing commits immediately; the node that lingers and fades is not a fact but an afterimage, and the only thing entitled to observe animation completion is the presentation layer (presence) that cleans up afterimages. It follows that new input always beats an in-flight animation, immediately.

```tsx
// Bad: the fact and the next action wait for the animation. 300 is a magic coupling paired with the duration
function handleClose() {
  setIsExiting(true);
  setTimeout(() => {
    setIsOpen(false);
    navigate("/inbox");
  }, 300);
}

// Good: the fact commits immediately. The exit afterimage is drawn and cleaned up by the presentation layer
function handleClose() {
  setIsOpen(false);
  navigate("/inbox");
}
```
