---
name: build
description: Build an implementation target using worktree, TDD, and PR workflow; use only when the user explicitly mentions this skill
---

# Build

Implement the requested target end-to-end, then create a pull request.

## Target Resolution

- If the user mentions a GitHub issue, plan file, spec, branch, file path, or concrete implementation target with `$build`, use that as the target.
- If no explicit target is provided, infer the target from the current conversation context.
- If multiple plausible targets exist and choosing one would be risky, ask the user to choose before changing files.

## Workflow

1. Use `$git-worktree` to create or enter a dedicated worktree for the target.
2. Read the target and relevant code until the required behavior is clear.
3. Use `$tdd` to implement with vertical red-green-refactor cycles.
4. Run the repository's full handoff gate after code changes, including lint, typecheck, tests, and any project-specific checks.
5. Commit the finished changes with a Conventional Commit, staging only the files changed for this target.
6. Use `$pr` to push the branch, create the GitHub pull request, and verify it.

## Reporting

- Keep progress updates concise and focused on completed phases, blockers, or decisions needed from the user.
- In the final response, include the PR URL, verification results, and any notable follow-up.
