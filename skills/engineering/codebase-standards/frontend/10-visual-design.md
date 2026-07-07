# Visual Design

The design system is the project's visual vocabulary, and call sites do not coin new words. Every color, space, size, and radius on screen is a token from the system's scales; a screen is composed from the vocabulary, never written in raw values. This is also what "not looking AI-generated" means in practice: the generic accent is not a taste problem but a discipline problem — it is what interfaces look like when call sites invent values instead of drawing from one system.

## Rules

**1. Every visual value comes from a token. A raw hex, pixel, or font size in a diff is a violation.**

If the design truly needs a value the scale lacks, that is a design decision: name it into the scale first, then use the name. The token layer owns more than consistency — it owns theming. Dark mode, density, and rebrands are one-place changes when every call site speaks in tokens, and impossible when values sit raw in components. Motion has its own scale under the same regime ([06-animation-conventions.md](06-animation-conventions.md)).

```tsx
// Bad: values invented at the call site, invisible to the theme
<p style={{ color: "#6d28d9", marginTop: 13, fontSize: 15 }}>…</p>

// Good: the call site knows only names from the scales
<p className="text-accent mt-3 text-sm">…</p>
```

**2. Color is a role, not a value.**

Components use semantic tokens — `text-muted`, `bg-surface`, `border-default`, `text-destructive` — never palette entries picked by hue. A role token answers "what is this element" and survives a theme switch; `purple-600` answers nothing and welds the screen to one palette. When the system lacks a role a screen needs, add the role to the system, not a hue to the component.

**3. Spacing encodes relationship.**

Spacing comes from the scale, and its job is grouping: related elements sit close, unrelated elements sit apart. Equal, generous padding around everything reads as calm but says nothing — hierarchy flattens and screens waste space. Deliberate contrast within the scale is what makes structure visible before a single word is read. Spacing between siblings belongs to the parent through `gap`, never to a child's outer margin ([01-component-composition.md](01-component-composition.md)).

**4. Typography is a ladder with fixed rungs.**

Type sizes and weights come from the scale, and heading levels are structure, not styling: one `h1` per screen, levels never skipped, heading tags never borrowed for visual emphasis. Readers scan by the ladder and screen readers navigate by it ([11-accessibility.md](11-accessibility.md)); a skipped rung breaks both.

**5. The generic-AI accent is a defect list, not a style.**

Each of these defaults is a decision dodged, and the remedy is always the same: the project's actual system.

| Default | The decision it dodges |
| --- | --- |
| Purple/indigo everywhere, gradient washes | The project has a palette; use it |
| `rounded-2xl` on every box | Radius is a scale with hierarchy: bigger surfaces, bigger radii |
| Uniform card grids | Layout follows information priority, not template symmetry |
| Equal oversized padding | Spacing encodes relationship (rule 3) |
| Stacked shadows on everything | Elevation is a scale with few levels, spent where depth means something |
| Lorem-ipsum copy | Realistic content is part of the layout: real names wrap, real numbers overflow, real sentences vary in length |
