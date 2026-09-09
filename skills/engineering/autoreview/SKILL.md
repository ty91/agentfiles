---
name: autoreview
description: Review a specified change with code-reviewer; when fixes are authorized, own the fix, verification, and re-review loop through completion.
---

# Autoreview

Own review orchestration and, when authorized, the correction loop. The `code-reviewer` subagent owns the review rubric and remains read-only. You validate its findings and own the final closeout result.

## Authority and scope

A standalone request to review is review-only. An implementation workflow or an explicit request to apply fixes authorizes in-scope self-checks, fixes, and verification without asking again. Honor any explicit review-only restriction. Inherit the caller's checkout, commit policy, and exclusions; this skill does not independently authorize commits, publication, or unrelated cleanup.

Resolve the target from the request and current context: PR, branch comparison, commit range, staged changes, working tree changes, or session changes. Establish the original task, acceptance criteria, intended behavior and ownership boundary, base and target state, and pre-existing changes to exclude. Infer missing details from available evidence; ask only when ambiguity prevents a correct review or safe in-scope work.

Keep the original task scope stable while including authorized fixes in subsequent review targets. Read surrounding code as needed to understand consequences, without expanding the work into a separate audit.

## Prepare the review

When fixes are authorized, perform the caller's requested self-checks before the first review. For changed tests, use the applicable testing standards to assess their value; make only the cleanup or structural changes needed for the task. Keep review-only requests free of edits and project execution.

When fixes are authorized, establish the verification needed to complete the task, including the caller's required checks and any permitted fallback when a check cannot run. Run outstanding checks, fix failures caused by the task, and record unrelated failures separately. Reuse earlier results while their code, configuration, and environment assumptions still apply. Follow the caller's commit policy for verified changes. For review-only requests, use supplied verification evidence and report gaps.

Build a thin review packet using references rather than long summaries:

- The exact review target and base, checkout location, exclusions, and current commit or uncommitted diff state.
- Relevant task, spec, acceptance criteria, repository conventions, and decisions; summarize only context unavailable through those references.
- Verification commands, results, the code state they cover, and remaining gaps.
- On later rounds, the previous findings, their disposition, and what changed since the last review.

Invoke `code-reviewer` with this packet. Let it use its own rubric and classification rules; do not duplicate those policies in the prompt. An incremental review may focus on fixes and affected paths when the rest of the target has already been reviewed and remains unchanged.

## Validate the result

Treat reviewer output as advisory. Check each finding against the relevant code path and evidence, consulting dependency contracts when needed. Remove unsupported or duplicate claims, correct locations and classifications, and retain valid confidence values and fix recommendations.

Apply the reviewer's classification rules consistently. Judge blocking findings by how this change causes the defect, not merely by the location of the underlying code. Evaluate generated-artifact findings by their meaningful consequences rather than dropping them based on file type. A larger required decision may justify an escalation; a preferred redesign does not.

Recompute the verdict after validating findings. Preserve incomplete coverage explicitly: `INCOMPLETE` or missing review context is not a clean review. Supply missing context and resume review when possible. Do not treat unavailable execution evidence alone as a code defect; whether it prevents task completion depends on the verification requirements established above.

For review-only requests, return the validated verdict, findings, and material verification gaps. This finishes the review request, not implementation closeout.

## Fix and re-review

When fixes are authorized:

1. Resolve accepted in-scope blockers with the smallest correct change. Leave follow-ups as recommendations; they do not require fixes or issue creation before completion. If an accepted escalation needs a decision outside the task, report that decision instead of expanding scope yourself.
2. Run checks affected by the changes and satisfy any remaining required verification. Treat failures caused by a fix as part of the same work. Commit proven, in-scope outcomes when the caller's policy requires it; do not commit speculative fixes while scope or verification is unresolved.
3. Re-review substantive code or test changes and their affected paths, then validate the result again. Keep the review packet current. Non-substantive changes need not trigger another review if the previous reasoning still applies.

The final task state must be covered by both review and required verification. If a later check causes another substantive edit, return to the loop. Once those obligations are satisfied, stop; do not request another clean review or rerun unchanged checks for reassurance.

If fixes keep failing or findings recur, reassess the cause, evidence, and approach before another edit. Continue while a concrete, in-scope approach can make progress. There is no fixed iteration or line-count limit, but do not repeat failed approaches without new evidence or conceal a task-scope change as another patch.

## Closeout

Return one of these outcomes to an implementation caller or a user who authorized fixes:

- **COMPLETE**: the final task state has been reviewed, no accepted in-scope blocker or escalation remains, required verification is satisfied through checks or a caller-permitted fallback, and any required fix commits are complete. Follow-ups may remain; disclose fallback verification and its limits.
- **DECISION REQUIRED**: completion needs an out-of-scope decision or additional authority. Preserve the useful analysis and describe the smallest decision and available options.
- **BLOCKED**: required context, environment, or verification cannot be obtained, or repeated fixes have failed with no new evidence supporting a viable approach. Report what remains unresolved, what was attempted, and what would enable progress.

Only `COMPLETE` permits an implementation caller to proceed to PR finalization. A reviewer's `APPROVE` is code-review evidence, not a substitute for this closeout check.

Keep the report concise: outcome, final target state, fixes made, remaining classified findings with file:line and confidence, verification results and material gaps, and any decision or blocker. Omit empty categories and the subagent transcript. Return control to the calling workflow when embedded in implementation; a successful review is not a reason to stop before its requested PR or other final deliverable.
