---
name: build
description: Implement one assigned task issue end-to-end in the current codebase. Use when the user provides a to-tasks sub-issue or other implementation issue and expects a focused codebase diff for that single task, not a plan, not all sibling tasks, and not a pull request.
---

# Build

## Mission

Implement exactly one task issue. The input is an implementation sub-issue, usually created by `to-tasks` and marked with `[pi:task]`. The output is a focused codebase diff that satisfies that one issue.

Do not process the parent issue's full plan. Do not implement sibling sub-issues. Do not create or update a `[pi:task-breakdown]` comment. Do not delegate implementation to a subagent. You are the implementer.

## Target Resolution

Resolve the task issue from the user's request. If the target is missing or ambiguous, ask which task issue to build.

Read the task issue directly. If it is a `[pi:task]` sub-issue, also read:

- Its parent issue, if linked.
- The `[pi:plan]` comment on the parent issue, if present.
- Any dependency sub-issues listed in the task body.
- Relevant project guidance such as `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, and `docs/agents/issue-tracker.md`.

Treat the task issue as the scope boundary. Parent plans and dependency issues provide context only; they do not authorize extra work.

Stop and ask before implementing if:

- The task issue has no clear acceptance criteria.
- A listed dependency is incomplete and blocks this task.
- The task contradicts the parent plan or current codebase.
- The required change is larger than the task issue describes.

## Workflow

1. Inspect the repo state with `git status --short`. Do not overwrite unrelated user changes.
2. Read the task issue and relevant code until the required behavior is clear.
3. Use the `tdd` skill when the task changes behavior or fixes a bug:
   - Write one failing test for one required behavior.
   - Make it pass with the smallest appropriate change.
   - Refactor only within the task scope.
4. Implement only the assigned task. Keep the diff narrow and consistent with existing patterns.
5. Run the task's listed verification commands. If the issue does not list commands, run the smallest relevant repo checks for the touched area.
6. Inspect the final diff with `git diff` and confirm it maps back to the task's acceptance criteria.
7. Do not create a PR or commit unless the user explicitly asks or the repo's task workflow requires it.
8. If issue tracker updates are expected, update only this task issue's checklist/status after verification. Do not modify the parent issue or sibling issues unless explicitly asked.

## Diff Discipline

- Leave unrelated changes untouched.
- Do not start cleanup outside the task scope.
- Do not hide failing verification. If verification cannot pass, keep the useful diff and report the blocker.
- Do not mark unchecked acceptance criteria as complete unless the code and verification satisfy them.

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
