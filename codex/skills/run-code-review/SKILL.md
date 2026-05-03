---
name: run-code-review
description: Run code review for the active work session, triage findings, and immediately fix only the necessary items
---

# Run Code Review

Review and fix the committed changes made in the active work session.

## Workflow

1. Identify the work repo/worktree for the active session. Use the repo where the session's changes were made; if unclear, ask.
2. Establish the session review range.
   - On the first run, set `BASE` to the commit before this session's first commit in that repo.
   - On repeated runs, reuse the same `BASE` and review `BASE..HEAD` again.
   - Use `HEAD~1..HEAD` only when this is the first run and the session made exactly one commit.
   - If `BASE` cannot be determined safely, ask.
3. Run `$code-review` from that repo/worktree with `BASE..HEAD`.
4. Triage every finding as `apply` or `skip`.
   - Apply: correctness, security, clear maintainability/readability/simplicity wins.
   - Skip: speculative, stylistic-only, out of scope, duplicate, already fixed, or riskier than the issue.
5. Implement only `apply` findings with minimal changes.
6. Verify with relevant checks.
7. Report the range, applied/skipped findings with reasons, and verification results.
