---
name: implement
description: Implement one assigned task issue end-to-end in the current codebase.
disable-model-invocation: true
---

## Autonomy and authority

- Complete the task end to end.
- Decide open implementation details conservatively without waiting for approval.
- Keep changes scoped to the task and leave unrelated cleanup alone.
- Ask the user only when:
  - completion is genuinely blocked, or
  - an ambiguous action is destructive or hard to reverse.

## Process

### 1. Prepare the worktree

- Create a new git worktree unless already inside a non-`main` worktree.
- Run all reads, writes, verification, and git operations inside that worktree.
- Install dependencies using the repository's package manager.

### 2. Understand the work and load the standards

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
- Read the `codebase-standards` map and every document triggered by the work.
- If tests may change, read the matching testing standards before deciding whether a test belongs.

### 3. Define commit checkpoints

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

### 4. Implement and commit each checkpoint

- Work on exactly one checkpoint at a time.
- Use `/tdd` where possible, at pre-agreed seams.
- Never manufacture a failing test merely to begin implementation.

When the checkpoint is complete:

1. Run the narrowest relevant verification.
2. Inspect the diff and stage only the checkpoint's changes.
3. Immediately create a Conventional Commit describing the completed outcome.

Do not start the next checkpoint until verification passes and the commit succeeds. Otherwise fix or split the checkpoint.

### 5. Verify the implementation

- After all implementation checkpoints, run the relevant repository checks.
- Treat any resulting code or test changes as another verified and committed checkpoint.

### 6. Review and refine

Unless `--no-review` was passed:

1. Run `review` after the implementation checkpoints are committed.
2. Provide the relevant `codebase-standards` documents and verification evidence.
3. Explicitly review:
   - excessive tests,
   - wrong test surfaces,
   - duplicated coverage,
   - refactors required to make the current change coherent.
4. Fix every required finding as a verified and committed checkpoint.
5. Re-run review after material structural or behavioral changes.
6. Continue until no required findings remain.

### 7. Finalize and create the pull request

- Run the full test suite.
- If it cannot run, record:
  - why it could not run,
  - the strongest verification completed instead.
- Inspect:
  - the branch commit list,
  - the complete task diff,
  - the final worktree status.
- Confirm:
  - every commit is coherent and belongs to the task,
  - the diff contains only task changes,
  - the worktree is clean except for explicitly excluded pre-existing changes.
- Create a pull request that includes:
  - a link to the task,
  - the implemented behavior,
  - important design decisions,
  - verification results.
