---
name: run-code-review
description: Run the code-review skill, decide which findings should be applied, and immediately fix only the necessary review items
---

# Run Code Review

Use when the user wants review findings collected and actionable items fixed.

## Workflow

1. Identify the repo/worktree changed by this task; run review/fix commands there. If unclear, ask.
2. Determine this task's committed range: task-start commit..HEAD, or `HEAD~1..HEAD` only when this task made exactly one commit. If unsafe, ask.
3. Run `$code-review` with that range.
4. For each finding, decide `apply` or `skip`.
   - Apply: correctness, security, clear maintainability/readability/simplicity wins.
   - Skip: speculative, stylistic-only, out of scope, or higher-risk than the issue.
5. Implement only `apply` findings. Keep changes minimal and within reviewed files unless the root cause requires otherwise.
6. Verify with the narrowest relevant checks, then the repo gate if practical.
7. Report applied/skipped findings with brief reasons and verification results.
