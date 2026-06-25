---
name: to-tasks
description: Break a plan, spec, or PRD into independently-grabbable tasks on the project issue tracker using tracer-bullet vertical slices.
disable-model-invocation: true
---

# To Tasks

Break a plan into independently-grabbable tasks using vertical slices (tracer bullets).

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes an issue reference (issue number, URL, or path) as an argument, fetch it from the issue tracker and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Task titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the plan into **tracer bullet** tasks. Each task is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

<vertical-slice-rules>

- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Any prefactoring should be done first

</vertical-slice-rules>

<task-sizing>

Try to keep each slice to a change you estimate at **~1000 LOC across ~8 files or fewer**, small enough to review in one sitting. You estimate this by analogy before any code exists; hold it as a ceiling, not a number to creep past. When a slice estimates over budget the tracer bullet is too wide: split it into thinner end-to-end slices, and lift any one-time scaffolding (a migration, a module's plumbing) into its own prefactoring slice.

</task-sizing>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tasks to the issue tracker

For each approved slice, publish a new task to the issue tracker. Use the issue body template below.

Write issue content primarily in Korean. Section names and established technical terms may remain in English when they are clearer or conventional.

Publish tasks in dependency order (blockers first) so you can reference real issue identifiers when wiring up relationships. Record each relationship in the template's "Parent" and "Blocked by" sections, and whenever the issue tracker supports native relationship features (e.g. parent/sub-issue or blocking/blocked-by links), always use those as well.

Once a task is triaged, the agentic engineering system picks it up automatically. So a task's relationships MUST be fully set up before you apply its triage label. These tasks are considered ready for agents, so apply the correct triage label as the final step unless instructed otherwise.

<issue-template>
## Parent

A reference to the parent issue on the issue tracker (if the source was an existing issue, otherwise omit this section).

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

Avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it here and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking ticket (if any)

Or "None - can start immediately" if no blockers.

</issue-template>

Do NOT close or modify any parent issue.
