---
name: architect
description: Design contracts, domain and state models, ownership, and module boundaries before implementing structural changes. Use for API design, architecture decisions, domain modeling, or refactors that redistribute responsibilities. Compare distinct designs and verify their contracts.
disable-model-invocation: false
---

# Architect

Make the caller's usage the specification. Model the domain before writing logic, give each rule and mutable state a clear owner, and hide implementation decisions behind a small contract.

## Scope and authority

Use this workflow when the task creates or changes a contract, state model, ownership boundary, or module responsibility. A local fix within an established contract does not need design exploration. If investigation reveals a structural cause, enter this workflow then.

Follow the requested scope: a design request ends at a design; an implementation request continues into implementation. This skill grants no additional authority to write code, delegate, commit, or publish. Express call sites and signatures in prose when code writing is not authorized. Project instructions and compatibility obligations remain constraints.

## Workflow

1. **Ground.** Read representative callers, the affected implementation, project terminology, and relevant decisions. State the requested behavior, existing contract, compatibility requirements, and exclusions. When changing ownership or layering, investigate why the current boundary exists. Distinguish evidence from inference.
2. **Write usage first.** Describe two or three realistic calls, their inputs, results, failures, and observable effects. Include the failure or state transition that could change the design. Derive the contract from these examples; reconcile types to usage, not usage to convenient internals.
3. **Model.** Read [Model the Domain](principles/model-the-domain.md) and [Boundary Discipline](principles/boundary-discipline.md). Define core data structures, valid states, invariants, state owners, and external boundaries. Trace dominant access patterns. For asynchronous work, define completion, cancellation, persistence authority, and recovery using [async-work.md](async-work.md).
4. **Compare.** Follow [comparing-alternatives.md](comparing-alternatives.md). Produce at least two structurally distinct candidates before selecting one. Read [Minimize Reader Load](principles/minimize-reader-load.md), then screen every candidate against [design-red-flags.md](design-red-flags.md). Prefer the shape that hides meaningful decisions behind a smaller contract while preserving invariants.
5. **Choose and sequence.** State the chosen contract, ownership changes, rejected alternative, and accepted tradeoffs. Read [Subtract Before You Add](principles/subtract-before-you-add.md). Name obsolete paths to remove and the smallest coherent implementation steps. Use [verify](../verify/SKILL.md) to define evidence for the contract before moving structure. For behavior-preserving work, establish the baseline first.
6. **Implement when authorized.** Fill in the chosen shape. Treat unplanned parameters, casts, branches, or caller coordination as evidence to investigate. Verify each coherent step. Do not silently weaken the contract to accommodate an implementation.
7. **Reopen a wrong design.** If the same workaround appears across independent paths, callers need internal knowledge, or the model repeatedly needs escape hatches, re-ground and compare new candidates. A single legitimate edge case does not condemn the design. Remove changes justified by a disproven assumption.

## References

Read the four principle files at their workflow steps. They own their rules; do not infer them from the titles. Read the remaining references when their condition applies.

- Unclear concepts, terminology, or relationships: [domain-modeling.md](domain-modeling.md)
- Stale responses, duplicate execution, partial failure, or retries: [async-work.md](async-work.md)
- Whether to wrap or combine modules: [reducing-caller-complexity.md](reducing-caller-complexity.md)
- UI structure that varies between callers: [compound-components.md](compound-components.md)

## Done

Return the caller's contract, state and responsibility changes, chosen and rejected shapes, accepted tradeoffs, and verification evidence or remaining gaps. A compact in-chat sketch is sufficient when a separate artifact adds no value. Preserve durable rationale through [documentation](../documentation/SKILL.md).

For a design-only task, label proposed checks as unexecuted. For implementation, continue the caller's workflow until its requested outcome is complete; a design sketch alone does not finish it.
