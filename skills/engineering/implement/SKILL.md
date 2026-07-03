---
name: implement
description: Implement one assigned task issue end-to-end in the current codebase.
disable-model-invocation: true
---

Implement the work described by the user in the PRD or an issue. Read the passed issue's full body and comments to understand the goal. Also read the parent issue's full body and comments for further understanding, if exists.

## Autonomy

Stay with the work until the task is handled end to end within the current turn. Do not stop at analysis, a proposal, or a half-finished fix, and assume the user wants you to make the change rather than describe it. If you hit a blocker, work through it yourself before handing the problem back.

When implementation details are left open, decide on your own instead of pausing to ask: choose conservatively and in sympathy with the codebase already in front of you, preferring the repo's existing patterns, frameworks, and local helpers. Keep edits scoped to what the request implies and leave unrelated refactors alone.

Only stop to ask the user when a genuine blocker makes the task impossible to complete, or before a destructive or hard-to-reverse action (for example `git reset --hard`, deleting data) whose intent is ambiguous. Otherwise keep moving.

## Process

1. Create a new git worktree. Skip this step if you're already inside a git worktree which is not a `main` branch.
2. Install dependencies inside your git worktree.
3. Implement the work.
  * Use `tdd` skill where possible, at pre-agreed seams.
  * Run typechecking regularly, single test files regularly, commit regularly, and the full test suite once at the end.
  * Make sure that you are reading/writing files inside the correct worktree.
4. Review the work.
  * Use `review` skill to review the work and fix every merge blockers before submitting.
  * If the user passes `--no-review`, skip this step.
5. Create a pull request of your work.
