---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured issue tracker with native blocking links.
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets** — tracer-bullet vertical slices, each declaring the tickets that **block** it.

The issue tracker should have been provided to you — run `/setup-repo` if not.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

### 4. Assess each slice's feasibility

The user steers with a coarse-grained understanding of the codebase and its problem domain; you are the one who just explored the code. Before presenting the breakdown, translate what you found into evidence the user can judge each slice by:

- **Touch surface**: the modules/directories the slice changes, and roughly how much. Concrete paths are fine here — this evidence lives in the conversation, not the issue body.
- **Blast radius**: how many call sites consume what the slice changes, and whether that code is shared or isolated.
- **Precedent**: whether the codebase already has a similar pattern to imitate, or the slice breaks new ground. Novelty predicts context consumption better than file count — the implementing agent starts from a fresh context window, and exploration eats the budget.
- **Riskiest unknown**: the one thing you are least sure about — the first thing the implementing agent would have to figure out.
- **Confidence**: 🟢 / 🟡 / 🔴 that the slice fits a single fresh context window, with a one-line reason.

**Probe before presenting a 🔴.** Codebase exploration (step 2) is optional in general; for a low-confidence slice it is not. Resolve the uncertainty with a targeted probe — grep the call sites, read the schema, check test coverage — and re-rate. If the probe cannot settle it, split the investigation into its own **spike ticket** (its deliverable is the answer, not code) that blocks the slices waiting on the answer. Never paper over uncertainty with an estimate.

### 5. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work
- **Feasibility**: the step-4 evidence — touch surface, blast radius, precedent, riskiest unknown, confidence

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct — does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?
- Can any riskiest unknown be resolved from their domain knowledge — or does it warrant a split or a spike?

Iterate until the user approves the breakdown. When the user's domain knowledge settles a riskiest unknown ("that table is being dropped — don't handle it"), fold the answer into the ticket so the implementing agent inherits the decision instead of rediscovering the question.

### 6. Publish the tickets to the configured tracker

Publish the approved tickets to the tracker `/setup-repo` configured (GitHub, Linear, …).

Write issue content primarily in Korean. Section names and established technical terms may remain in English when they are clearer or conventional.

An orchestrator watches the tracker and auto-implements any issue labeled `ready-for-agent`, respecting its blocking edges. The label is the trigger, so it must come LAST — after every link is in place. Follow this order strictly:

1. **Publish** one issue per ticket, in dependency order (blockers first) so each ticket's "Blocked by" section can reference real identifiers. Do NOT apply any triage label yet.
2. **Link to the parent issue** (if the source was an existing issue), using the platform's native sub-issue / parent relationship where it has one.
3. **Link the blocking edges** between tickets, using the platform's native blocking relationship where it has one; otherwise rely on each ticket's "Blocked by" section.
4. **Apply the `ready-for-agent` triage label** to every ticket, unless instructed otherwise — the tickets are agent-grabbable by construction.

Do NOT close or modify any parent issue.

<issue-template>

## Parent

A reference to the parent issue on the tracker (if the source was an existing issue, otherwise omit this section).

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective — not layer-by-layer implementation.

## Interface changes

The interfaces this ticket adds or changes — API endpoints, function/module signatures, schemas, events, CLI flags — described at the contract level, not as implementation. Omit this section if the ticket changes no interface.

## Screen layout

The screens or UI states this ticket adds or changes — layout, key elements, and user-visible states, in prose or a rough sketch. Omit this section if the ticket has no UI.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking ticket, or "None — can start immediately".

</issue-template>

In issue bodies, avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

To implement manually instead of leaving the tickets to the orchestrator, work the **frontier** — any ticket whose blockers are all done — one ticket at a time with `/implement`, clearing context between tickets.
