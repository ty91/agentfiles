---
name: implement
description: Implement one assigned task issue end-to-end in the current codebase.
disable-model-invocation: true
---

# Implement

Implement exactly one task issue. The input is an implementation sub-issue, usually created by `to-tasks` and marked with `[pi:task]`. The output is a focused codebase diff that satisfies that one issue.

## Target Resolution

Resolve the task issue from the user's request. If the target is missing or ambiguous, ask which task issue to implement.

Read the task issue directly. If it is a `[pi:task]` sub-issue, also read:

- Its parent issue, if linked.
- The `[pi:plan]` comment on the parent issue, if present.
- Relevant project guidance such as `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, and `docs/agents/issue-tracker.md`.

Treat the task issue as the scope boundary. Parent plans and dependency issues provide context only; they do not authorize extra work.

Stop and ask before implementing if:

- The task issue has no clear acceptance criteria.
- A listed dependency is incomplete and blocks this task.
- The task contradicts the parent plan or current codebase.
- The required change is larger than the task issue describes.

## Workflow

0. Change the task issue's status to in-progress.
1. Inspect the repo state with `git status --short`. Do not overwrite unrelated user changes.
2. Read the task issue and relevant code until the required behavior is clear.
3. Create a new git worktree for the task.
4. Use the `tdd` skill to implement the task.
5. Inspect the final diff with `git diff` and confirm it maps back to the task's acceptance criteria.
6. Create a pull request.

## Completion Report

Report the result concisely:

```markdown
## Task Issue
<issue URL or identifier>

## Summary
- [What changed]

## Diff
- [Files changed and why]

## Verification
- `<command>` -- pass/fail

## Issue Update
- [Checklist/status update performed, or "not updated"]

## Blockers / Risks
- [Anything still requiring user action, or "none"]
```
