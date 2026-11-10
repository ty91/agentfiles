# Minimize Reader Load

Judge a design by the layers a reader must trace and the hidden or mutable state they must remember. File length, export count, and line count are not the objective.

- Prefer a small public contract that hides substantial decisions. Learning the interface should save callers from learning the implementation.
- Collapse pass-through layers and speculative indirection that hide no policy or complexity. A forwarding boundary earns its place through a real adaptation, policy, naming contract, or environment boundary.
- Consolidate ordering, validation, and cleanup that callers otherwise repeat. Do not turn unrelated responsibilities into an options-heavy wrapper.
- Reduce mutable scope: returned values before mutations, locals before fields, fields before module state, and module state before globals. Derive values rather than synchronizing copies.
- Name and enforce an invariant at its owning boundary, not separately in every consumer.
- Make dependencies and ownership traceable. A new layer or state must remove at least as much understanding burden elsewhere as it adds.

Trace where a representative value comes from and who can change it. If answering requires reconstructing unrelated layers or hidden state, simplify the boundary or state model. Keep a refactor only when it reduces reader load somewhere without violating the contract.
