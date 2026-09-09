---
name: implement
description: Implement one assigned task issue end-to-end in place by default, or on a new branch or worktree when requested.
disable-model-invocation: true
---

## Execution mode

Use at most one execution-mode flag. `--in-place` is the default.

- `--in-place`: Work in the current checkout without creating or switching branches or worktrees. The default branch is allowed.
- `--new-branch`: Create and switch to a new task branch from the current `HEAD`, using the current checkout.
- `--new-worktree`: Create a new task branch and linked worktree from the current `HEAD`, then work there.

## Autonomy and authority

- Complete the task end to end.
- Decide open implementation details conservatively without waiting for approval.
- Keep changes scoped to the task and leave unrelated cleanup alone.
- Ask the user only when:
  - completion is genuinely blocked, or
  - an ambiguous action is destructive or hard to reverse.

## Process

### 1. Prepare the checkout

- Record the starting commit, branch, and working tree status.
- Apply the selected execution mode.
- Preserve pre-existing changes and keep them out of task commits.
- Run all reads, writes, verification, and git operations in the selected execution location.
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
- If tests may change, load the `tests` skill and the repo's own testing standards before deciding whether a test belongs.

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
- Use `/tdd` where possible. The test surface defaults to the outermost consumer seam per the `tests` skill; a red below it is legitimate only under that skill's justification list.
- Never manufacture a failing test merely to begin implementation: if a checkpoint is internal plumbing, it is covered by driving the outer acceptance red green, not by a red of its own.

When the checkpoint is complete:

1. Run the narrowest relevant verification.
2. Inspect the diff and stage only the checkpoint's changes.
3. Immediately create a Conventional Commit describing the completed outcome.

Do not start the next checkpoint until verification passes and the commit succeeds. Otherwise fix or split the checkpoint.

### 5. Verify the implementation

- After all implementation checkpoints, run the relevant repository checks.
- Treat any resulting code or test changes as another verified and committed checkpoint.

### 6. Review and refine

Unless `--no-review` was passed, invoke `autoreview` after the implementation checkpoints are committed, with authorization to own in-scope self-checks, fixes, verification, and re-review through completion. Pass:

- The task's acceptance criteria, resolved task diff and base, checkout, and excluded pre-existing changes.
- Verification commands and results already obtained, including the code state they cover, and this skill's checkpoint commit policy.
- These self-checks to perform before the first review:
  - each TDD-added test against the suite-review checklist in the `tests` skill (`principles.md`) — in particular: if the behavior it names broke, would an outer required test already turn red? Remove or consolidate tests that fail the checklist,
  - refactors required to make the current change coherent.
- Final verification: run the full test suite, reusing a completed result if it still applies. If it cannot run, record why and the strongest verification completed instead; this is the permitted fallback unless repository requirements demand otherwise.

When using `autoreview`, proceed to finalization only after it returns `COMPLETE`. For `DECISION REQUIRED` or `BLOCKED`, report the unresolved condition instead of creating a PR or claiming completion. Any subsequent substantive code or test change must return through review and affected verification before finalization.

If `--no-review` was passed, skip `autoreview` and the reviewer subagent; perform the same self-checks and final verification directly, committing resulting changes under the checkpoint policy. This flag does not waive verification or authorize broader changes.

### 7. Finalize and create the pull request

- Inspect:
  - the branch commit list,
  - the complete task diff,
  - the final working tree status.
- Confirm:
  - every commit is coherent and belongs to the task,
  - the diff contains only task changes,
  - the working tree is clean except for explicitly excluded pre-existing changes.
- If the current branch is not the default branch, create a pull request that includes:
  - a link to the task,
  - the implemented behavior,
  - important design decisions,
  - verification results.
- If working in place on the default branch, do not create or switch branches for a pull request, and do not push unless explicitly requested.
