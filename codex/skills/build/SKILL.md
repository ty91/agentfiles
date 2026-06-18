---
name: build
description: Delegate sequential task implementation to worker with worktree, TDD, per-task commits, task-breakdown updates, and PR workflow.
---

# Build

Implement the requested spec issue's task breakdown end-to-end, then create a pull request.

You own orchestration, not inline implementation. Resolve the target, prepare the worktree, then delegate each task to the `task-implementer` subagent in order, verify each result, track progress, run the final gate, and open the PR. The per-task TDD, verification, and commit work is delegated to the subagent.

## Target Resolution

Resolve the spec issue from the user's request. If it is unclear, ask the user which spec issue to build.

Find the `[pi:task-breakdown]` comment on the spec issue. Treat the `## Task N:` sections in that comment as the implementation queue, and work through incomplete tasks strictly in order. Do not skip ahead unless an earlier task is already complete.

A task is complete only when its implementation is done, its task-specific verification is satisfied, its changes are committed, and the task's checklist items in the `[pi:task-breakdown]` comment have been checked. If the comment cannot be found, the ordered task sections cannot be determined, or there are no incomplete tasks remaining, stop and report the blocker.

## Workflow

1. Use the `git-worktree` skill to create or enter a dedicated worktree for the spec issue.
2. If you created a new worktree, install its dependencies before continuing.
3. Read the spec issue, the `[pi:task-breakdown]` comment, and relevant code until the required behavior and task order are clear.
4. Dump the `[pi:task-breakdown]` comment to `TODO.md`.
5. For each incomplete `## Task N:` section, strictly in order — sequentially, never in parallel, since the tasks share one worktree and build on each other:
   - Delegate the task to the `task-implementer` subagent. Pass a thin packet: the worktree path, the exact `## Task N:` section (description, acceptance criteria, checklist items, and verification commands), and references to the spec issue, relevant code, and project convention files. Do not restate the TDD or commit discipline in the prompt; the subagent owns it.
   - When the subagent returns, verify its result against `git log` and `git diff`: confirm the commit exists, stages only that task's files, and that its verification passed. If the subagent reports a blocker or its result does not hold up, stop and report rather than proceeding to the next task.
   - Update the `TODO.md` file to check the completed task's checklist items, and any checkpoint checklist items that are now satisfied. Do not check future task items or unsatisfied checkpoint items.
6. After all task sections are complete, run the repository's full handoff gate, including lint, typecheck, tests, build, and any project-specific checks.
7. If the final handoff gate requires fixes, make a final Conventional Commit for those fixes and update the `TODO.md` file for any newly satisfied final checkpoint items.
8. Update the `[pi:task-breakdown]` comment with `TODO.md`, then remove the local `TODO.md` file.
9. Use the `pr` skill to push the branch, create the GitHub pull request, and verify it.

## Reporting

- Keep progress updates concise and focused on the current task number, worker status, blockers, or decisions needed from the user.
- In the final response to the user, summarize completed tasks, commits, task-breakdown update status, PR URL, validation results, cleanup result, and any notable risks or follow-up.
