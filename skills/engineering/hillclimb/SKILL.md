---
name: hillclimb
description: Iteratively improve one measurable outcome against a target using a validated measurement harness, architecture-grounded hypotheses, and measured keep-or-revert decisions. Use for explicit hillclimb requests, not a one-off fix.
disable-model-invocation: true
---

# Hillclimb

Own the metric and experiment integrity. One hypothesis, one measured change, keep or revert. Never accumulate unverified changes or claim improvement from code inspection.

## Scope and authority

Follow the user's scope, repository instructions, and permissions for implementation, delegation, commits, and publication. This skill grants no additional authority. Preserve pre-existing work. A planning request ends with an experiment plan; an execution request continues through measured results.

Read linked skills in full when their step applies. Resolve links relative to this file; report a missing dependency rather than inventing its workflow. Track steps and evidence, recording a reason for any skipped conditional step.

## Workflow

1. **Ground and reproduce.** Read representative callers, implementation, project decisions, and existing measurements. Trace the real execution path and identify workload dimensions such as data size, history, state, and concurrency. Select a realistic case reproducing the complaint; repair the reproduction before optimizing if none does. Distinguish observations from hypotheses.
2. **Fix the experiment contract.** Name one primary metric, unit, better direction, target, minimum attempt count, and correctness constraints. Use the user's numbers; otherwise agree on the target and attempt floor before running. Success requires both target and attempt floor, for example 50% lower latency and at least 10 attempts. Set a noise threshold and the result that would change a decision before measuring. Honor any time or resource budget separately from success.
3. **Build, validate, and freeze the harness.** Build the smallest rerunnable tool that proves the claim. Read and apply Measurement integrity below. Confirm contrasting realistic workloads separate as expected and the target case reproduces the symptom. If they do not, revise the workload or metric. Freeze the workload, command, environment settings, sampling, and acceptance rule. Print the metric, errors, and completed work count. Record the initial baseline and a passing regression gate through [verify](../verify/SKILL.md) before changing product code.
4. **Open the decision trail.** Apply Decision trail below before the first attempt. Read prior attempts before selecting each hypothesis. Keep raw measurements and profiles in artifacts; retain only the architecture model, decisions, and evidence pointers in the main context.
5. **Choose a mechanism.** Tie each hypothesis to an observed path and a specific cause, such as deferring work that blocks first paint. For performance, consider in order: remove unused work; avoid repeated work; do less; do it later; do it when the user is not waiting; do it concurrently; make it cheaper. Borrow this ordering, not a one-off fix's early-stop rule. When a change affects contracts, state, ownership, or module responsibility, read [architect](../architect/SKILL.md) and complete its design steps before implementation.
6. **Run one attempt.** Apply Attempt below. Finish measurement, correctness checks, disposition, and logging before building on that change. Independent experiments may run in isolated workspaces under Delegation below.
7. **Respond to a plateau.** Several rejected attempts trigger a different category, source reinspection, a new combination of near-misses, or a more fundamental hypothesis. Treat combinations as new measured attempts. If two fixes sharing a premise fail the same gate, write down and directly test that premise before another fix assumes it. Do not confuse a plateau with completion.
8. **Stop and deliver.** Succeed only when the fixed target and attempt floor hold. Otherwise stop when the budget is exhausted, progress is blocked, or remaining ideas are marginal relative to cost; report the unmet predicate and reason. Do not weaken the goal, spin indefinitely, or stop while cheap useful hypotheses remain within budget. Audit the trail and verify the final accepted state. Preserve accepted changes in verified order; use [pr](../pr/SKILL.md) when PR delivery is authorized. Apply [documentation](../documentation/SKILL.md) when durable contracts or operating assumptions change.

## Measurement integrity

- **Explain the number.** Read what the script times, counts, and ignores. Identify the limiting resource or code path using a separate profiling run or system counters, then map it to source. Check the load generator too. Do not report profiler-instrumented timing as ordinary performance.
- **Compare equivalent work.** Use realistic production builds, flags, versions, data, batching, pools, and cache conditions. Tune both sides appropriately before choosing a winner. Record environment load; remove interference when authorized or interleave comparisons and disclose it.
- **Check plausibility.** Compare throughput with resource limits and claimed savings with the fraction of work changed. Investigate impossible gains, cached results, skipped work, errors, and no-ops before trusting the result.
- **Count real success.** Validate outputs and error counts. Confirm work completed inside the measured region, including awaited asynchronous work and consumed lazy results. A fast failure or discarded result is not a win.
- **Clear the noise.** For performance, run each side at least five times, alternating A/B; report median and range. A gap within run-to-run variation is no measurable improvement. For a close result, use appropriate statistics or more samples within budget. For other metrics, define equivalent repeated trials that test reliability and relevance.
- **Measure user impact.** Pair microbenchmarks with the real end-to-end path, realistic sizes, and concurrency. Explain the changed component's share of the whole. Missing limiter evidence, untuned comparisons, or unchecked errors/work make a performance verdict inconclusive.
- **Preserve comparability.** Compare each candidate with the current accepted state; retain the initial baseline for total improvement. If the harness is defective, pause, repair and revalidate it, version the experiment, and remeasure both reference and candidate. Never join incompatible measurements or alter the harness to favor a candidate.

## Attempt

1. Read the trail and state the hypothesis, expected mechanism, bounded change, and evidence that would accept or reject it. Keep the measurement contract outside the implementer's write scope.
2. Implement or delegate within the authorized scope. Review the actual diff and preserve behavior, compatibility, and unrelated changes. Favor deletion and the smallest coherent change over abstractions added only to improve a number.
3. Measure before and after with the frozen harness and run the regression gate through [verify](../verify/SKILL.md). Inspect outputs yourself; a delegate's success report is not evidence.
4. Keep a performance change only when improvement exceeds noise and the gate passes. Revert an incorrect change even if faster. A demonstrable simplification may be kept when the metric does not regress beyond noise and correctness holds; label it a simplification, not a measured performance win. Reject inconclusive or speculative improvements and revert only that attempt's changes in full.
5. When commits are authorized, create one commit per accepted coherent change, staging explicit task paths or hunks. Otherwise preserve the same reviewable boundaries without committing. Log every attempt, including rejects, with evidence before proceeding.

## Delegation

When authorized and available, delegate bounded implementation attempts; the parent retains experiment design, diff review, measurement judgment, and integration. Follow the environment's agent tooling and configured models, choosing effort appropriate to the task rather than hardcoding a provider. If delegation is unavailable, disclose that and execute sequentially within scope.

For independent hypotheses, use separate worktrees and owned outputs. Do not share mutable branches or logs. Keep canonical decisions with one writer. Parallel implementation does not make simultaneous timing reliable: isolate resources or serialize measurements. Rebase and remeasure each candidate against the latest accepted state before integrating it; wins measured separately may not compose.

For unattended work, use an available authorized continuation mechanism without borrowing another workflow's stop rule. Preserve the experiment state and blockers when continuation is unavailable.

## Decision trail

Keep one local, gitignored `decision.tsv`, one row per attempt: `id`, `hypothesis`, `change`, `before`, `after`, `delta`, `tests`, `verdict`, `evidence`, `note`. Use single-line cells and resolvable artifact or commit pointers. Distinguish `improved`, `simplified`, `reverted`, and `inconclusive`; record whether an inconclusive change was reverted. Keep measurement runs, environment, harness version, and stop-predicate state in linked artifacts.

Append corrections rather than rewriting history. On resumption, read the trail and verify the checkout and harness still match its accepted state. Before handoff, reconcile decisions and claims with actual diffs, runs, and available session records; add missing pivots and superseding corrections. When authorized and available, obtain a different model family's independent review of the trail and evidence. Report absent review or evidence honestly. Keep the trail local unless an auditable committed record is requested or required.

## Report

Return the metric and target; initial and final values with units, percentage change, sample count, spread, and limiter; attempts split into improvements, simplifications, and reverts; accepted changes; regression evidence; trail and artifact paths; and the exact stop reason. Distinguish achieved, unmet, and inconclusive outcomes. Include review flags and remaining limitations. Give untried hypotheses only when requested.
