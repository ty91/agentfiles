---
name: cohesion-axis
description: Shared vocabulary and stance for choosing the cohesion axis — what code is grouped around. Use when deciding where new code should live, when one feature's code is scattered across role folders, when shaping a project's folder structure, when mirroring a screen's regions into code, or when another skill needs the cohesion-axis vocabulary.
---

# Cohesion Axis

Every grouping decision in a codebase answers one question: **what do we cohere around?** This skill is the vocabulary and the stance for that question. Carry it wherever code is placed, a structure is shaped, or a "where does this go?" comes up — in discussion or while writing code. The folder layout is the *output*; the axis is the *decision*, and it is the thing worth being deliberate about.

The master move is choosing between two axes:

- **Role axis** — group by technical kind: all hooks together, all services together, all components together.
- **Meaning axis** — group by what the code is *about*: a domain, a feature, a screen region, the life of one piece of data.

Default lean: pure, reusable, domain-free code coheres on the **role** axis; anything that carries domain coheres on the **meaning** axis. Slicing domain code by role alone is the root cause of fragmentation.

## Glossary

Use these terms exactly. Consistent language is what lets the principles stay active across a whole session.

**Cohesion axis** — the dimension code is grouped along. A *choice*, not a fixed answer: role axis vs meaning axis. _Avoid_: naming "folder structure" as the subject; that is the output, not the decision.

**Fragmentation** — the failure state: one feature's or one domain's code scattered across role folders (components / hooks / services / store), so following its data flow means hopping between directories. The smell that says the axis is wrong. _Avoid_: blaming file count — many files cohered on the right axis are fine; few files split across the wrong one are not.

**Duality** — pure UI components and domain components differ in kind. Pure UI is reusable and domain-free (role axis). Domain components are bound to business context (meaning axis); forcing them to be reused across contexts breeds props and conditionals. _Avoid_: treating all components as one population.

**Lifecycle cohesion** — one candidate meaning axis: group code along a datum's life — acquire → transform → compute → present. Following the code becomes following the data, like reading one pipeline end to end.

**Mental-model alignment** — the compass and the stance. Actively mirror *how the user thinks about the system* and *how the screen's semantic regions look* into the axis. This is a posture to hold, not a checklist to complete: the right axis is the one that matches the model already in the user's head and on the screen.

## Choosing the axis

When code carries domain, pick a **meaning axis**. The compass for *which* meaning axis is mental-model alignment — match how the system is actually carved in the user's head and on the screen. Common candidates:

- **Entity** — group around a source datum (Product, Cart): what is shown.
- **Screen region / widget** — group around a visual section of a page (ImageGallery, ReviewSection): where it sits and how it is laid out. The screen's visual carving is a ready-made meaning axis.
- **Feature / action** — group around one user action (search, checkout) from trigger to completion: how and why.
- **Lifecycle** — group around one datum's flow through the system.

These are not exclusive; a real structure mixes them at different altitudes. The point is to choose on purpose, name the choice, and hold it — not to drift into role-only slicing by default.

## Two modes

- **Early / greenfield** — the axis is not in the code yet, so work it out with the user. Mirror their words and the screen's regions back, and surface the axis as an explicit, confirmable decision rather than silently picking one.
- **Mature / existing** — the axis already lives in the code, so read it first. Place new code where similar concerns already sit. If the existing axis is itself causing fragmentation, name it instead of quietly diverging.

## Relationships

- **Cohesion axis and deep modules are orthogonal.** This skill is *how the codebase is carved into groups* (horizontal). `codebase-design`'s **deep module** is *how much behaviour hides behind one module's interface* (vertical). A well-placed group can still be a shallow module, and vice versa — use both lenses.
- **The meaning axis usually tracks domain boundaries.** When those boundaries need pinning down as terminology, that is `domain-modeling`'s job; this skill consumes the boundaries it produces.
- **Component colocation and prop-drilling limits** (see `frontend-ui-engineering`) are low-altitude instances of these principles at a single component.

## Rejected framings

- **Structure as a recipe to copy.** A named layout pasted across projects ignores that the axis is a per-project decision that bends to scale and team. Choose the axis; let the folders fall out.
- **Cohesion as a static virtue.** "Be cohesive" is a no-op; the live decision is *which* axis to cohere around, made on purpose each time.
