# Model the Domain

Apply when choosing data structures, writing stateful behavior, or changing a rule repeated across branches or files.

- Name the concepts, lifetimes, invariants, and actors before writing logic. Use the project's terms; clarify ambiguous concepts through [domain-modeling.md](../domain-modeling.md).
- Represent valid combinations directly. Prefer a state machine or discriminated union to synchronized booleans and optional-field bags; a map or registry to distributed branching; a reducer or command model to uncoordinated mutations.
- Group values that must stay consistent. Give each mutable state and shared rule one owner. Consumers read it or request a change through its contract.
- Organize modules around the knowledge they protect, not merely load, validate, transform, and save phases. Keep code that changes for the same reason together.
- Choose collections for the dominant reads and writes. Trace the access patterns now instead of deferring a necessary index or cache until implementation.
- Make illegal states hard to construct. Distinguish semantic primitives when mixing them would be a defect, exhaust variants, and derive types from authoritative schemas. Keep the simplest type that handles all valid inputs without casts or impossible-state assertions.
- A new abstraction must remove duplicated rules, invalid states, branches, or lifecycle risk. If the current code is clear and local, keep it. Similar-looking statements alone do not establish shared knowledge.

Check the model against a normal case, a boundary case, and the relevant state transition. Every invariant must have an owner and a place where it is enforced.
