---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable GitHub sub-issues using tracer-bullet vertical slices. Use when user wants to convert a parent issue, plan, or spec into implementation sub-issues, create implementation tickets, or break down work into issues.
---

# To Issues

Break a plan into independently-grabbable GitHub sub-issues using vertical slices (tracer bullets).

The source spec should usually be a GitHub parent issue created by `to-spec`. If the parent issue is not clear, ask the user which issue should own the sub-issues before publishing anything.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes an issue reference (issue number, URL, or path) as an argument, fetch it and read its full body and comments.

For GitHub issues, use `gh issue view <number-or-url> --comments` and capture the parent issue number and URL. The parent issue must remain the source of truth for the overall spec.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain vocabulary, and respect ADRs or existing design docs in the area you're touching.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Publish as sub-issues under the parent issue

For each approved slice, publish a new GitHub issue using the issue body template below, then attach it as a sub-issue of the parent issue. These issues are considered ready for AFK agents unless marked HITL or instructed otherwise.

Publish issues in dependency order (blockers first) so you can reference real issue identifiers in the "Blocked by" field.

Use the repo's existing labels only when they are already known. Do NOT invent labels. If the repo has an agreed "ready for agent" label, apply it to AFK sub-issues; otherwise leave labels alone.

After creating each child issue, attach it to the parent issue using GitHub sub-issues. The REST API needs the child issue's REST `id`, not the issue number:

```sh
child_url="$(gh issue create --title "$title" --body-file "$body_file")"
child_number="$(gh issue view "$child_url" --json number --jq '.number')"
child_rest_id="$(gh api "repos/:owner/:repo/issues/$child_number" --jq '.id')"
gh api --method POST "repos/:owner/:repo/issues/$parent_number/sub_issues" -F sub_issue_id="$child_rest_id"
```

If GitHub rejects the sub-issue attachment, stop and report the error. Do NOT silently publish a flat list of issues that are not connected to the parent.

<issue-template>
## Parent

A reference to the parent issue on GitHub.

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

Do NOT close or modify the parent issue except to attach approved sub-issues.
