---
name: codebase-design
description: Design or improve contracts, data and state models, module responsibilities, and dependency boundaries. Use for architectural choices, domain modeling, or refactoring that changes how code is organized.
---

# Codebase Design

Reduce what callers need to know. Give shared rules, changes, and failure handling clear owners. Start with the project's terminology and existing structure.

## Workflow

1. Read relevant callers, implementation, project documentation, and decisions. Identify the requested behavior and compatibility to preserve.
2. Define inputs, results, failure modes, and important invariants. For asynchronous work, clarify what completion means and who may persist results.
3. Trace which code changes together when a requirement changes, then assign responsibilities accordingly.
4. Choose the simplest change that satisfies the current need. Explore alternatives when they involve meaningful trade-offs.
5. Check the changed contract against representative calls and relevant failures. Use [tests](../tests/SKILL.md) to choose verification and [documentation](../documentation/SKILL.md) when context needs to persist.

## Decision criteria

- **Contracts:** Use names and types to expose inputs, outputs, and failures. Declare public input and return types when inference leaves the contract unclear. Distinguish a missing result from an error.
- **Data and state:** Group values that must stay consistent. Represent mutually exclusive states so valid combinations are visible. Preserve domain meaning without adding unnecessary nesting.
- **Responsibilities:** Keep code that changes for the same reason together; separate independently changing responsibilities. Evaluate change impact and caller effort rather than file length or export count.
- **Reuse:** Extract a shared rule when callers need it to stay consistent. Similar appearance alone may not justify shared code. Reconsider an abstraction when its options and conditional behavior keep growing.
- **Dependencies:** Supply dependencies at a composition point when environments vary or execution needs control. Small code with a fixed implementation need not gain speculative alternatives or injection layers.
- **Effects:** Separate calculation from I/O when mixing them makes reasoning or verification difficult. Give persistence and transmission code explicit completion, failure, and cleanup responsibilities.
- **Inputs and errors:** Validate external data where it enters the system. Type assertions do not validate values. Give users actionable messages while preserving causes and useful diagnostic context.

## References

Read only what the task needs.

- Unclear concepts, terminology, or relationships: [domain-modeling.md](domain-modeling.md)
- Stale responses, duplicate execution, partial failure, or retries: [async-work.md](async-work.md)
- Whether to wrap or combine modules: [reducing-caller-complexity.md](reducing-caller-complexity.md)
- Comparing materially different contracts: [comparing-alternatives.md](comparing-alternatives.md)
- UI structure that varies between callers: [compound-components.md](compound-components.md)

## Done

Finish when the caller's contract, responsibility changes, and remaining constraints are clear. A small change may need only code and a brief explanation, not a separate design document.
