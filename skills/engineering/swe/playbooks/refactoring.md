# Refactoring

Change structure while preserving observable behavior. Use [implement](../../implement/SKILL.md) as the execution owner.

1. Read implement and [verify](../../verify/SKILL.md), then prepare the selected checkout once. Identify representative callers, the existing contract, important effects, and compatibility constraints.
2. Before moving structure, establish the behavior baseline through verify's change-verification path. Run appropriate existing coverage and fill material gaps with a characterization or equivalence check. Typecheck and lint alone do not establish runtime equivalence.
3. Use [architect](../../architect/SKILL.md) when changing contracts, state representation, ownership, or module responsibilities. Compare distinct shapes and state which caller knowledge, duplicated rule, invalid state, or tracing burden the chosen shape removes. Local mechanical edits within established boundaries do not need a separate architecture exercise.
4. Apply the target through implement's coherent checkpoints, keeping the preserved contract verified. Follow architect's subtraction and compatibility rules. Track removed paths and consumers, including non-code references.
5. Compare the resulting behavior against the baseline through verify. Keep the structural change only when its benefit is concrete. Newly discovered bugs or feature ideas do not silently become part of the refactor; report them separately unless the user authorizes a scope change.
6. Complete implement's review and finalization. Use [documentation](../../documentation/SKILL.md) for changed ownership, terminology, or durable rationale.

Report the structural change, the contract preserved, evidence of equivalence, and the reduction in reader or caller burden. Explicit TDD does not require manufacturing a red for a behavior-preserving internal move; follow verify's [test-first guidance](../../verify/test-first.md).
