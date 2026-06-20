---
name: to-plan
description: Create an implementation plan comment for a spec issue without decomposing it into detailed tasks or sub-issues. Use when a feature/spec issue needs architecture direction, execution phases, risks, and human approval before detailed task creation; use to-tasks separately after the plan is approved to create sub-issues.
---

# To Plan

## Overview

Turn a spec issue into a concise implementation plan. The plan explains the approach, major phases, dependencies, risks, and open questions. It does not create detailed task breakdowns, task checklist comments, local planning files, or sub-issues.

## Source Spec

Start from the spec issue the user provides. The source spec must be an issue in the repo's configured issue tracker.

If the target is missing or ambiguous, ask which spec issue to plan from. Do not choose one yourself.

If the user provides a local spec document instead of an issue, stop and ask which issue tracker issue should contain the plan, or ask whether to create/import the spec into an issue first. Do not create local planning files.

If the repo has `docs/agents/issue-tracker.md`, follow it for fetching and updating issue details and comments. Otherwise, use the repo's configured issue-tracker workflow. If the workflow is unclear, ask the user how to read and comment on the issue before continuing.

The spec issue is the source of truth for product intent and scope. If the spec is stale, incomplete, or contradicted by the codebase, stop and ask whether to revise the spec before writing the plan.

## Output

Create or update exactly one planning comment on the spec issue:

```markdown
[pi:plan]
```

Use a visible marker line, not a hidden HTML comment, because issue tracker editors may sanitize or transform hidden comments.

If an existing `[pi:plan]` comment is found, update it instead of creating a duplicate. If the issue tracker workflow does not support comment updates, create a new comment with the same marker and state that it supersedes the previous one.

Do not create a `[pi:task-breakdown]` comment. Do not create sub-issues. Detailed implementation tasks belong to the `to-tasks` skill after the plan is approved.

Do not close or otherwise modify the spec issue unless the user explicitly asks.

## Planning Process

### 1. Read First

Before writing any code, operate in read-only mode:

- Read the spec and relevant codebase sections.
- Identify existing patterns and conventions.
- Map major dependencies between components.
- Note risks, unknowns, and decisions that need human review.

**Do not write code during planning.** The output is a plan comment, not implementation.

### 2. Decide The Shape

Describe the implementation strategy at a planning level:

- Major architecture decisions and rationale.
- Dependency order between phases.
- Data, API, UI, migration, test, release, or documentation concerns.
- Explicit risks and mitigations.
- Open questions that block or may change the work.

Keep the plan implementation-aware enough to guide the next step, but do not write per-task acceptance criteria, file lists, or verification commands. Those belong in sub-issues created by `to-tasks`.

### 3. Publish And Ask

Publish the `[pi:plan]` comment, then ask the user to review it before detailed task creation:

> Plan written to `<issue-url>`. Please review it and let me know if you want changes before I split it into sub-issues with `to-tasks`.

## Plan Comment Template

Write the plan comment primarily in Korean. Established technical terms may remain in English when they are clearer or conventional.

```markdown
[pi:plan]

# Implementation Plan: [Feature/Project Name]

## Overview
[One paragraph summary of what will be built and why.]

## Architecture Decisions
- [Decision 1 and rationale]
- [Decision 2 and rationale]

## Execution Phases

### Phase 1: [Name]
[Planning-level description of the outcome and dependencies.]

### Phase 2: [Name]
[Planning-level description of the outcome and dependencies.]

### Phase 3: [Name]
[Planning-level description of the outcome and dependencies.]

## Risks and Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk] | [High/Med/Low] | [Strategy] |

## Open Questions
- [Question needing human input]
```

## Verification

Before finishing, confirm:

- [ ] The source spec was read from the user-provided issue tracker issue.
- [ ] Existing repo patterns and relevant code were considered.
- [ ] A single `[pi:plan]` comment was created or updated on the spec issue.
- [ ] No `[pi:task-breakdown]` comment, local planning file, or sub-issue was created.
- [ ] The plan is suitable for a later `to-tasks` pass.
- [ ] The human was asked to review the plan before task creation.
