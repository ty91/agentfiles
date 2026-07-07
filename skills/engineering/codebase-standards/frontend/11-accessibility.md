# Accessibility

A screen is not done when it looks right for a mouse user on the happy path. Done means: every interaction works from the keyboard, every element announces itself to assistive technology, every asynchronous moment has a designed state, and every viewport gets a working layout. None of this is an enhancement layer to add later — it is the definition of working UI, and retrofitting it costs multiples of building it in.

## Rules

**1. Semantic elements first; everything interactive is keyboard-operable.**

`button`, `a`, `label`, `input`, and `select` are focusable, operable, and announced for free. A clickable `div` is none of these, and recreating them by hand — `role`, `tabIndex`, key handlers — is a last resort for widgets HTML does not have, built once in the design system rather than per screen. Verification is mechanical: leave the mouse alone and Tab through the screen; everything reachable, everything operable, focus always visible. A focus ring is removed only by replacing it with a clearer one.

```tsx
// Bad: invisible to the keyboard and announced as nothing
<div className="btn" onClick={handleSave}>Save</div>

// Good: operable and announced for free
<button onClick={handleSave}>Save</button>
```

**2. Every control has an accessible name.**

Icon-only buttons carry `aria-label`; inputs are tied to a `label`, or carry `aria-label` when the design hides one; images that inform carry `alt`, images that decorate carry `alt=""`. Where a visible label exists, the accessible name matches it — a voice-control user operates the screen by saying what they see.

```tsx
// Bad: announced as "button"
<button><TrashIcon /></button>

// Good: announced as "Delete comment"
<button aria-label="Delete comment"><TrashIcon /></button>
```

**3. Focus is managed wherever content changes under the user.**

Opening a dialog moves focus into it, traps it there, and returns it to the trigger on close. Removing the element that holds focus hands focus somewhere deliberate, never lets it fall to `body`. This behavior lives in the design system's dialog and popover primitives, implemented once; a screen that hand-rolls an overlay owns all of it by hand, and will forget some of it ([01-component-composition.md](01-component-composition.md): compose the primitive, do not recreate it).

**4. Color never carries meaning alone, and text earns its contrast.**

A state expressed only as red-versus-green is invisible to a meaningful share of users; pair the color with a word or an icon. Text meets contrast against its actual background — 4.5:1 for normal text, 3:1 for large. Semantic tokens ([10-visual-design.md](10-visual-design.md)) turn contrast into a property of the system, checked once per token pair instead of per screen.

**5. Every data-bearing screen ships loading, empty, and error states — or it is not done.**

- **Loading** reserves the shape of what is coming, so arrival does not shift the layout — the space-reservation rule of [08-virtualized-lists.md](08-virtualized-lists.md), applied to whole screens.
- **Empty** says what the absence means and offers the next action; a blank region reads as a defect, because to the user it is one.
- **Error** says what failed and offers retry when retrying can help; a dead end with no way forward strands the user in the failure.

Mutation progress is a different subject: it derives from the mutation transition and sits at its trigger ([05-mutation-patterns.md](05-mutation-patterns.md)). This rule is about screens waiting for data they read.

**6. Layout is mobile-first, and every viewport gets a working screen.**

Styles start at the narrowest viewport and add complexity upward at breakpoints; building up is additive, while stripping a desktop layout down is guesswork. Content reflows rather than overflows, and horizontal scrolling exists only where content is deliberately wide — a table, a code block — inside its own scroll container. Before calling a screen done, verify it at 320, 768, 1024, and 1440.
