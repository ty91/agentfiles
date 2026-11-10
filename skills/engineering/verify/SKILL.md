---
name: verify
description: Establish and run evidence for changed behavior, regression fixes, and behavior-preserving refactors. Use when choosing or writing tests, assessing test value, checking real system boundaries, or asked for TDD, test-first, or red-green-refactor.
disable-model-invocation: false
---

# Verify

Start with the promise the change must keep, then choose the observation that can disprove it. Tests, scripts, real application runs, and static checks establish different claims. Name what each proves.

## Scope and authority

Follow the caller's scope, execution permission, and repository requirements. A request to choose verification may end with a plan; it does not authorize running external effects. Preserve pre-existing changes. This skill does not authorize commits, deployment, production writes, or weakening checks.

The caller owns required final checks and permitted fallbacks. Reuse evidence only while its code, configuration, and environment assumptions still hold. An unavailable check stays unverified even when the caller permits completion with a fallback.

## Workflow

1. **State the claims.** Identify observable behavior, invariants, important failure modes, changed boundaries, and compatibility to preserve. Read existing checks and project guidance. For structural changes, use the contract from [architect](../architect/SKILL.md); reopen design only when evidence exposes a structural problem.
2. **Choose the path.** Use change verification below for ordinary work and behavior-preserving refactors. Use [regression.md](regression.md) for bug fixes. An explicit TDD or test-first request selects [test-first.md](test-first.md); a request for integration tests alone does not.
3. **Choose the evidence.** Read [Test Behavior, Not Implementation](principles/test-behavior-not-implementation.md) and [test-design.md](test-design.md) before writing, changing, retaining, or removing tests. Select the narrowest check that observes the claim at the layer where the risk lives. Read [frontend.md](frontend.md) or [backend.md](backend.md) when those boundaries are involved.
4. **Execute and inspect.** Read [Prove It Works](principles/prove-it-works.md). Run authorized checks against the intended code and environment, inspect the actual result and effects, and record what the observation covers. A failed setup is not a reproduced defect. A passing mock is not evidence about the real boundary it replaced.
5. **Resolve and report.** Fix task-caused failures when authorized, then rerun affected checks. Keep unrelated failures separate. Remove or merge tests made redundant by the change only after checking what failures they own. Report each claim as verified, failed, or unverified, with commands, results, covered code state, and remaining limits.

## Change verification

- Reuse types, schemas, and existing checks when they already establish the claim. Do not add a test merely because a file changed. Copy and styling changes may need inspection or a rendered check rather than new automated tests.
- For a behavior-preserving refactor, establish the current contract before moving structure. Run suitable existing coverage; where it leaves a material gap, capture a characterization test, snapshot, or equivalence check. Typecheck and lint alone do not establish runtime equivalence.
- Verify each coherent unit before building further on it. Compare old and new behavior through the same interface and relevant failure cases. Do not manufacture a failing test for an internal-only change that preserves the contract.
- Do not change expected behavior or weaken assertions to fit a faulty implementation. An intended contract change must have evidence in the task or an authorized decision, and its checks must express that contract.
- Keep verification changes and product changes distinguishable. A broken harness and a product bug are different findings; do not repair one by hiding the other.

## Evidence handoff

Give implementation and review callers a compact record: claim, check, observed result, code state, and limits. For regressions, include failing-before and passing-after evidence or explain the missing baseline. Include tests added, removed, and run when applicable. Unexecuted checks are plans, not passes.

The read-only code reviewer inspects code and supplied evidence. It does not execute this workflow. The parent owns execution and verification gaps through [autoreview](../autoreview/SKILL.md); a review approval alone does not establish runtime correctness.
