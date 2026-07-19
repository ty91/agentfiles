---
name: review
description: Conduct a multi-axis code review with the code-reviewer subagent.
---

Invoke the `code-reviewer` subagent to review the target. After the subagent returns, inspect its findings against the available diff and context, remove unsupported or duplicate claims, then report the final review to the user.

## Review Scope

The detailed five-axis rubric lives in the `code-reviewer` subagent. You own orchestration: resolve the review target, gather the relevant context, invoke the reviewer, verify the review output, and report the final result.

## Process

### Step 1: Resolve the Review Target

Interpret the user's target as a PR, branch, commit range, staged changes, working tree changes, or "my changes" from the current session. Ask a clarifying question only if the target is still ambiguous.

Do not edit code. This command is review-only; the user will explicitly ask for fixes if they want changes applied.

### Step 2: Build a Thin Review Packet

Pass references, not long summaries. The `code-reviewer` subagent should independently inspect the relevant files and history.

Include:

- Review scope, such as `git diff main...HEAD`, `git diff --staged`, a PR number or URL, or the relevant commit range
- Relevant reference paths or URLs, such as spec, plan, task, issue, PR description
- Project convention files when readily identifiable, such as `AGENTS.md`, `CONTRIBUTING.md`, `context.md`, or `plan.md`
- Any user-specified review focus or constraints

Summarize only ephemeral conversation context that the subagent cannot access directly.

### Step 3: Invoke the Reviewer

Invoke the `code-reviewer` subagent with the review packet. Ask it to read the references directly, use its built-in review rubric, and return classified findings (in-scope blocker, follow-up, or stop-and-escalate) with file:line references, confidence, fix recommendations, and any verification gaps.

Do not restate the full review rubric in this prompt; the subagent owns the review criteria.

### Step 4: Inspect the Review Result

After the subagent returns, treat review output as advisory. Never blindly apply it.

- Verify every finding by reading the real code path and adjacent files.
- Read dependency docs/source/types when the finding depends on external behavior.
- Reject unrealistic edge cases, speculative risks, broad rewrites, and fixes that over-complicate the codebase.
- Remove or clearly mark findings that are unsupported, duplicate, speculative, or based on incorrect line references.
- Demote findings anchored outside the reviewed change from in-scope blocker to follow-up.
- When an accepted finding shows a bug class or repeated pattern, inspect the current review scope for sibling instances.

Preserve valid classifications, confidence values, and fix recommendations.

### Step 5: Report the Final Review

Report review results only. Do not make code changes.

Lead with findings ordered most severe first, grouped by classification: in-scope blockers, then stop-and-escalate, then follow-ups. Each concrete issue should include file:line, problem, and recommended fix. If there are no findings, say that clearly. Include remaining test gaps, verification gaps, and residual risks. Do not paste the subagent transcript verbatim unless the user asks for it.

## Handling Disagreements

When resolving review disputes, apply this hierarchy:

1. **Technical facts and data** override opinions and preferences
2. **Style guides** are the absolute authority on style matters
3. **Software design** must be evaluated on engineering principles, not personal preference
4. **Codebase consistency** is acceptable if it doesn't degrade overall health

**Don't accept "I'll clean it up later."** Experience shows deferred cleanup rarely happens. Require cleanup before submission unless it's a genuine emergency. If surrounding issues can't be addressed in this change, require filing a bug with self-assignment.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "It works, that's good enough" | Working code that's unreadable, insecure, or architecturally wrong creates debt that compounds. |
| "I wrote it, so I know it's correct" | Authors are blind to their own assumptions. Every change benefits from another set of eyes. |
| "We'll clean it up later" | Later never comes. The review is the quality gate -- use it. Require cleanup before merge, not after. |
| "AI-generated code is probably fine" | AI code needs more scrutiny, not less. It's confident and plausible, even when wrong. |
| "The tests pass, so it's good" | Tests are necessary but not sufficient. They don't catch architecture problems, security issues, or readability concerns. |

## Reporting

- Lead with findings, ordered most severe first and grouped by classification.
- Include file and line references for each concrete issue.
- If there are no findings, say so clearly.
- Include any test gaps, verification gaps, or residual risks that remain after the review.
- Keep the report concise; do not paste the subagent transcript verbatim unless the user asks for it.

## Fix Loop

This command stays review-only until the user asks to apply fixes. When they do, run this closeout loop; it is a closeout gate, not permission to rewrite the task.

Before the first fix cycle, freeze a scope baseline: original request or issue, target branch, intended behavior, owner boundary, changed files, and non-test LOC.

- If a review-triggered fix changes code, rerun focused tests and rerun the review.
- Keep going until the review returns no accepted/actionable findings only while the work remains inside the original task scope.
- Do not stack or push review-triggered fix commits while scope classification or focused proof is unresolved. Keep exploratory edits local until the cycle is proven in scope; if scope breaks, remove them from the landing lane instead of preserving them as branch history.

Stop patching and report the scope break instead of continuing when:

- a narrow change turns into an architecture change, protocol change, migration, or release-process change;
- the diff grows past 2x the original files or non-test LOC without explicit approval to expand scope;
- two review-triggered patch cycles have not converged; pause and reclassify every remaining finding before another edit;
- the best fix is "define the canonical contract first" rather than another local inference layer;
- fixing the accepted finding would make the change no longer describe the same behavior, issue, or owner boundary.

After the two-cycle pause, continue only when every remaining accepted finding is still an in-scope blocker. Otherwise preserve the useful analysis, identify the smallest safe landed subset if one exists, and open or request a follow-up for the larger fix. Do not keep committing speculative fixes just to satisfy the reviewer.

Critical exceptions must be explicit: active data loss, crash, broken install/upgrade, release blocker, or concrete security exposure. If the exception is not one of those, it is not critical enough to blow up scope.

Stop as soon as the review returns no accepted/actionable findings. Do not run an extra review just to get a nicer "clean" line, a second opinion, or clearer closeout wording.
