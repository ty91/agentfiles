---
name: run-code-review
description: Run the code-review skill, decide which findings should be applied, and immediately fix only the necessary review items
---

# Run Code Review

Use when the user wants review findings collected and actionable items fixed.

## Workflow

1. Run `$code-review` for the requested `A..B` target. If no target is provided, ask for one.
2. For each finding, decide `apply` or `skip`.
   - Apply: correctness, security, clear maintainability/readability/simplicity wins.
   - Skip: speculative, stylistic-only, out of scope, or higher-risk than the issue.
3. Implement only `apply` findings. Keep changes minimal and within reviewed files unless the root cause requires otherwise.
4. Verify with the narrowest relevant checks, then the repo gate if practical.
5. Report applied/skipped findings with brief reasons and verification results.
