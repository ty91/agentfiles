---
name: implement-issue
description: Implement one assigned task issue end-to-end in the current checkout, without preparing a worktree or branch.
disable-model-invocation: true
---

## Autonomy and authority

- Complete the task end to end.
- Decide open implementation details conservatively without waiting for approval.
- Keep changes scoped to the task and leave unrelated cleanup alone.
- Ask the user only when:
  - completion is genuinely blocked, or
  - an ambiguous action is destructive or hard to reverse.

## Preconditions

- The current checkout is already prepared for this task, whether it is a linked git worktree or a plain branch checkout. Never create a worktree, and never create or switch branches.
- Run all reads, writes, verification, and git operations in the current checkout.
- If the current branch is the repository's default branch, stop and ask before making changes.
- Install dependencies using the repository's package manager if they are not installed yet.

## Process

### 1. Understand the work and load the standards

- Read:
  - the issue or PRD body and comments,
  - the parent issue body and comments, when present,
  - relevant repository instructions and project context,
  - applicable ADRs.
- Identify:
  - requested behavior,
  - acceptance criteria,
  - affected module interfaces,
  - explicit non-goals.
- If tests may change, load the `tests` skill and the repo's own testing standards before deciding whether a test belongs.

### 2. Define commit checkpoints

Before editing, list ordered commit checkpoints in the working plan.

A checkpoint is the smallest independently reviewable outcome that leaves the repository coherent:

- one observable behavior,
- one working prerequisite for a later behavior,
- or one cohesive review-driven refactor.

Never use these as checkpoint boundaries:

- technical layers,
- test phases or cycles,
- elapsed time,
- line counts.

A small task may have one checkpoint.

### 3. Implement and commit each checkpoint

- Work on exactly one checkpoint at a time.
- Use `/tdd` where possible. The test surface defaults to the outermost consumer seam per the `tests` skill; a red below it is legitimate only under that skill's justification list.
- Never manufacture a failing test merely to begin implementation: if a checkpoint is internal plumbing, it is covered by driving the outer acceptance red green, not by a red of its own.

When the checkpoint is complete:

1. Run the narrowest relevant verification.
2. Inspect the diff and stage only the checkpoint's changes.
3. Immediately create a Conventional Commit describing the completed outcome.

Do not start the next checkpoint until verification passes and the commit succeeds. Otherwise fix or split the checkpoint.

### 4. Verify the implementation

- After all implementation checkpoints, run the relevant repository checks.
- Treat any resulting code or test changes as another verified and committed checkpoint.

### 5. Review and refine

Unless `--no-review` was passed:

1. Run `autoreview` after the implementation checkpoints are committed.
2. Explicitly review:
   - each TDD-added test against the suite-review checklist in the `tests` skill (`principles.md`) — in particular: if the behavior it names broke, would an outer required test already turn red? Remove or consolidate tests that fail the checklist,
   - refactors required to make the current change coherent.

### 6. Finalize and create the pull request

- Run the full test suite.
- If it cannot run, record:
  - why it could not run,
  - the strongest verification completed instead.
- Inspect:
  - the branch commit list,
  - the complete task diff,
  - the final working tree status.
- Confirm:
  - every commit is coherent and belongs to the task,
  - the diff contains only task changes,
  - the working tree is clean except for explicitly excluded pre-existing changes.
- Create a pull request that includes:
  - a link to the task,
  - the implemented behavior,
  - important design decisions,
  - verification results.
