# Reducing Caller Complexity

When callers repeat the same ordering, validation, or cleanup rules, consider moving that responsibility behind one contract. This can produce a deep module, but implementation size and method count are not the goals.

## Evaluate the change

1. Identify the ordering, state, configuration, and error handling callers currently need to understand.
2. Compare the caller knowledge removed by consolidation with the configuration and dependencies it introduces.
3. Keep implementation that changes together cohesive; preserve independently changing parts as internal components.
4. Exercise the proposed contract with representative calls and relevant failures.

An upload interface can stay simple while coordinating validation, storage, and scheduling. A wrapper with dozens of options for unrelated jobs may leave callers with just as much to understand.

A small wrapper can earn its place through naming, type conversion, or framework integration. Delegation alone is not grounds for deletion, and sharing a process is not grounds for merging modules.

## Dependencies and verification

Place dependencies that need substitution at composition points. Choose boundaries by environment differences, ownership, and reasons for change rather than implementation count. Internal responsibilities need not become caller-visible configuration.

Identify contracts and verification to preserve before changing structure. Follow [test review](../tests/principles.md) when retaining, moving, or consolidating tests. A new outer test alone does not make existing tests disposable.
